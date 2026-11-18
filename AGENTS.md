# AGENTS.md

The NixOS configuration of four machines, as one flake. This file tells coding agents (and people)
how the repository is laid out, how to find things in it, and how to check a change.

## Hosts

| Host  | Role                                                       | Updates                                  |
| ----- | ---------------------------------------------------------- | ---------------------------------------- |
| lulu  | server: searxng                                            | every night at 03:30, from `main`        |
| tyke  | server: adguardhome, jellyfin, invidious, calibre-web      | every night at 05:00, from `main`        |
| tony  | desktop: Plasma                                            | by hand; a reminder once a week behind   |
| tuffy | desktop: niri and noctalia                                 | by hand; a reminder once a week behind   |

Both servers put their services behind caddy, on subdomains of `poire.me`.

## Ground rules

- **`main` is what runs.** lulu and tyke upgrade from `main` every night, and roll back on their own
  when their health checks fail. Anything merged reaches them that night, so work on a branch and
  open a pull request.
- **Don't deploy or rebuild the machines.** Their owner does. Evaluating and building locally is fine.
- **Secrets** in `secrets/` are encrypted with sops, for the age keys listed in `.sops.yaml`. Never
  decrypt or print them, and never commit a plaintext secret. Modules use them through
  `sops.secrets` and `sops.templates`.
- **Commits** follow conventional commits, with a subject under 50 characters. Details go in the
  body.
- `flake.lock` and `modules/services/container-images.json` are updated every Saturday by the
  `update-inputs` workflow (`.github/workflows/`). Don't update them as part of an unrelated change.

## Layout

```
flake.nix                     inputs; the outputs are flake-parts over import-tree ./modules
modules/flake/per-system.nix  the formatter (nix fmt) and the packages (pi, update-images)
modules/core/                 what every host needs: boot, nix, users, ssh, sops, maintenance
modules/core/maintenance/     nightly upgrades, health checks, rollback, the desktop reminder
modules/services/             server services: caddy, adguardhome, jellyfin, invidious, ...
modules/extra/                desktops, apps, development tools, terminal, virtualisation
modules/hosts/<host>/         configuration.nix (what the host imports) and hardware-configuration.nix
packages/                     derivations, exposed as flake packages
secrets/                      sops-encrypted files
dotfiles/                     user dotfiles, applied with GNU stow (dotfiles/sync.sh), not by Nix
```

## How modules work

- import-tree loads **every `.nix` file under `modules/`** as a flake-parts module, so a new file needs
  no registration. Paths containing `/_` are skipped, which is the place for helpers that are not
  modules.
- A file defines `flake.nixosModules.<name>`, and a host imports modules by name in its
  `configuration.nix`: `imports = with self.nixosModules; [ caddy jellyfin ... ];`.
- A module's name usually matches its file name, but not always: `core/boot/systemd.nix` defines
  `systemd-boot`, `core/users/ayoub.nix` defines `ayoub-user`, `core/net/nm.nix` defines `networking`.
  Search by name: `grep -rn 'nixosModules.<name> ' modules`.
- A host's `configuration.nix` and `hardware-configuration.nix` both define `nixosModules.host<Name>`,
  and flake-parts merges the two.
- The repository's own options live under `core.*`, `svc.*` and `app.*`.
- A module that **declares options** can only be imported once per host: a second import declares
  them again, and evaluation fails. Import it from a single place; for example `health` comes in
  through `auto-upgrade`.
- A service declares, next to itself:
  - its reverse proxy, `svc.caddy.subdomains.<name>.extraConfig`, served as
    `<name>.<svc.caddy.domain>`
  - its health check, `core.health.checks.<name> = { unit; url; command; }`
- Container images are pinned by digest in `modules/services/container-images.json`.
  `nix run .#update-images` points them at their tags' current digests.

## Finding things

Evaluating usually answers faster than reading:

```sh
nix eval .#nixosModules --apply builtins.attrNames               # every module name
nix eval .#nixosConfigurations.tyke.config.core.health.checks --apply builtins.attrNames
nix eval .#nixosConfigurations.tyke.config.services.caddy.virtualHosts --apply builtins.attrNames
nix eval --raw .#nixosConfigurations.tyke.config.systemd.services.nixos-upgrade.script
nix eval --raw .#nixosConfigurations.tyke.pkgs.path              # the pinned nixpkgs source
nix repl                                                         # then :lf . and tab completion
```

- **Upstream NixOS options and modules:** read them in the pinned nixpkgs, under the path that the
  last command prints, for example `<path>/nixos/modules/services/...`. The flake follows
  nixos-unstable, so memory of an older release is often wrong.
- **What sets an option:** `grep -rn '<option.path>' modules`.
- **Which hosts use a module:** `grep -rnw '<name>' modules/hosts`.

## Checking a change

```sh
nix fmt                       # nixfmt-tree over the whole tree
statix check .                # lints, configured by statix.toml
deadnix --fail .              # unused bindings and arguments
nix flake check --no-build    # evaluates all four hosts, the packages and the formatter
```

- **Tools:** the pre-commit hooks in `.pre-commit-config.yaml` run the first three (`pre-commit
  install` once per clone). Where the tools aren't installed, use `nix run nixpkgs#statix -- check .`,
  and the same for the others.
- **Building:** `--no-build` only evaluates. Building a whole host is slow and downloads a lot:
  `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`.
- **Shell code:** shell in `pkgs.writeShellApplication` is shellchecked when it's built, for example
  with `nix build .#update-images`. Shell in a unit's `script`, `preStart` or `postStart` isn't. Extract
  it and check it:
  `nix eval --raw .#nixosConfigurations.<host>.config.systemd.services.<unit>.script > /tmp/s.sh`,
  then `nix run nixpkgs#shellcheck -- -s bash /tmp/s.sh`.
- **Workflows:** `nix run nixpkgs#actionlint`.

## Gotchas

- **A flake only sees the files git knows.** A new file stays invisible to `nix` until it's
  `git add`ed. `nix eval path:.#...` reads the working tree as is, untracked files included.
- **Commit hash:** `system.configurationRevision` records the commit a machine runs, which
  `nixos-version --configuration-revision` shows. It's `unknown` when evaluated through `path:`.
- **`restartUnits` starts units:** sops-nix runs from a systemd unit (`sops.useSystemdActivation`),
  and a `restartUnits` entry *starts* that unit even when it's stopped. Leave it out for services that
  are off on purpose, like `calibre-docker`.
- **Only 2 generations:** each host keeps only its last 2 system generations and boot entries
  (`core/tools/nix.nix`). The rollback relies on that; see `core/maintenance/rollback.nix`.

## On a machine, for its owner

```sh
sudo nixos-rebuild switch --flake github:eg-ayoub/nix-files#<host>    # deploy main by hand
health-check 0                                                        # servers: run the checks once
journalctl -u nixos-upgrade -u auto-upgrade-rollback                  # servers: the last upgrades
cat /var/lib/auto-upgrade/events                                      # servers: failures and rollbacks
```

A server deployed by hand from another branch goes back to `main` at its next nightly upgrade.
