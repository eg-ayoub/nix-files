{ ... }:
{
  flake.nixosModules.health =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.core.health;

      check = lib.types.submodule {
        options = {
          unit = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "systemd unit that must be active";
          };
          url = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "URL that must answer without an HTTP error; https URLs go to the local caddy";
          };
          command = lib.mkOption {
            type = lib.types.nullOr lib.types.lines;
            default = null;
            description = "shell commands that must succeed";
          };
        };
      };

      curl = "${pkgs.curl}/bin/curl -fsS -o /dev/null --max-time 10";
      systemctl = "${config.systemd.package}/bin/systemctl";

      # https URLs are resolved to 127.0.0.1, so a check covers caddy and its certificate without
      # depending on public DNS
      fetch =
        url:
        let
          host = builtins.match "https://([^/:]+).*" url;
          resolve = lib.optionalString (
            host != null
          ) "--resolve ${lib.escapeShellArg "${builtins.head host}:443:127.0.0.1"}";
        in
        "${curl} ${resolve} ${lib.escapeShellArg url}";

      check-script =
        name: c:
        pkgs.writeShellScript "health-${name}" ''
          set -eu
          ${lib.optionalString (c.unit != null) "${systemctl} is-active --quiet ${lib.escapeShellArg c.unit}"}
          ${lib.optionalString (c.url != null) (fetch c.url)}
          ${lib.optionalString (c.command != null) c.command}
        '';

      health-check = pkgs.writeShellApplication {
        name = "health-check";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          # usage: health-check [timeout in seconds, default 300; 0 for a single pass]
          # retries failing checks every 10 seconds until they pass or the timeout runs out
          timeout=''${1:-300}
          deadline=$(( $(date +%s) + timeout ))

          declare -A checks=(
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (name: c: "[${lib.escapeShellArg name}]=${check-script name c}") cfg.checks
            )}
          )
          declare -A errors=()
          mapfile -t pending < <(printf '%s\n' "''${!checks[@]}" | sort)

          while [ ''${#checks[@]} -gt 0 ]; do
            failing=()
            for name in "''${pending[@]}"; do
              if output=$("''${checks[$name]}" 2>&1); then
                echo "ok    $name"
              else
                failing+=("$name")
                errors[$name]=$output
              fi
            done
            [ ''${#failing[@]} -eq 0 ] && break
            if [ "$(date +%s)" -ge "$deadline" ]; then
              for name in "''${failing[@]}"; do
                echo "FAIL  $name ''${errors[$name]}"
              done
              exit 1
            fi
            pending=("''${failing[@]}")
            sleep 10
          done
          echo "healthy"
        '';
      };
    in
    {
      options.core.health.checks = lib.mkOption {
        type = lib.types.attrsOf check;
        default = { };
        description = "what must work for this host to count as healthy; services declare their own";
      };

      config = {
        environment.systemPackages = [ health-check ];

        # a new boot entry gets 3 attempts; one that never reaches boot-complete.target is skipped in
        # favour of the previous generation
        boot.loader.systemd-boot.bootCounting.enable = true;

        # same pattern as systemd-boot-check-no-failures.service: the entry is only marked good once
        # the services are healthy
        systemd.services.health-check-boot = {
          description = "Health check before marking the boot entry good";
          after = [ "multi-user.target" ];
          before = [ "boot-complete.target" ];
          requiredBy = [ "boot-complete.target" ];
          onFailure = [ "health-check-boot-failed.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${lib.getExe health-check} 600";
          };
        };
        systemd.services.health-check-boot-failed = {
          description = "Reboot into the next boot attempt after a failed health check";
          # only while systemd-boot is still counting attempts for this entry; after it fell back to a
          # previous generation, a failure must not start a reboot loop
          unitConfig.ConditionPathExists = "/sys/firmware/efi/efivars/LoaderBootCountPath-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${systemctl} reboot";
          };
        };
      };
    };
}
