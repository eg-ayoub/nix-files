{ ... }:
{
  flake.nixosModules.openwebui =
    {
      pkgs,
      ...
    }:
    let
      # open-webui 0.12.3 (via `posthog`) still expects the mcp 1.x client
      # function name `streamablehttp_client`, while nixpkgs ships mcp 2.x
      # where it was renamed to `streamable_http_client`. That makes nixpkgs
      # mark `posthog` as broken, which in turn makes open-webui unbuildable.
      # Shim the old name back into mcp and un-break posthog (its tests need
      # the mcp 1.x API, hence doCheck = false for both).
      mcpShim = pfinal: pprev: {
        posthog = pprev.posthog.overridePythonAttrs (old: {
          meta = old.meta // {
            broken = false;
          };
          doCheck = false;
        });

        mcp = pprev.mcp.overridePythonAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            # keep the mcp 1.x alias used by posthog
            echo "streamablehttp_client = streamable_http_client" >> src/mcp/client/streamable_http.py
          '';
          doCheck = false;
        });
      };
    in
    {
      config = {
        # scoped to this module: only posthog/mcp (and their dependants) change
        nixpkgs.overlays = [
          (final: prev: {
            # `python3` is the interpreter `python3Packages` (and thus open-webui)
            # is built with; python314 is its alias in current nixpkgs.
            python3 = prev.python3.override {
              packageOverrides = mcpShim;
            };
            python314 = prev.python314.override {
              packageOverrides = mcpShim;
            };
          })
        ];

        services.open-webui = {
          enable = true;
          host = "127.0.0.1";
          port = 9120;
          package = pkgs.open-webui;
        };

        svc.caddy.hosts."ai.poire.me".extraConfig = ''
          reverse_proxy localhost:9120
        '';
      };
    };
}
