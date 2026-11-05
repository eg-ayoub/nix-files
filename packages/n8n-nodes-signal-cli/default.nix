# n8n community node for Signal via signal-cli
# (https://github.com/FGRibreau/n8n-nodes-signal-cli)
#
# The upstream repo (and the published npm sdist) ship no package-lock.json,
# so we inject our own (./package-lock.json) in postPatch and pin its
# dependency closure via npmDepsHash. The sdist already contains a built
# dist/, so we skip `npm run build` (dontNpmBuild). The lockfile only
# carries production dependencies (upstream devDeps have an `only-allow
# pnpm` preinstall hook that breaks the offline fetch), hence package.json
# is also stripped of its devDependencies block.
#
# To bump the version: update version/src hash, regenerate the lockfile
# (npm install --package-lock-only, drop "dev": true entries), then
# recompute npmDepsHash with `nix run nixpkgs#prefetch-npm-deps -- package-lock.json`.
{ pkgs, lib }:
pkgs.buildNpmPackage {
  pname = "n8n-nodes-signal-cli";
  version = "0.3.0";

  src = pkgs.fetchurl {
    urls = [
      "https://registry.npmjs.org/n8n-nodes-signal-cli/-/n8n-nodes-signal-cli-0.3.0.tgz"
    ];
    hash = "sha256-MZyhnTvz4grSQKTxIU0MX1R+SrnXUYA7NK3SpEPO8AU=";
  };

  npmDepsHash = "sha256-IBOzKKEgYNhTrbsS6LktrG3ZuD+32kkyR5593qBAFnw=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    sed -i -E '/"devDependencies": \{/,/^ *\}/d' package.json
  '';

  # dist/ is prebuilt in the sdist
  dontNpmBuild = true;

  meta = {
    description = "n8n community nodes for interacting with Signal CLI";
    homepage = "https://github.com/FGRibreau/n8n-nodes-signal-cli";
    changelog = "https://github.com/FGRibreau/n8n-nodes-signal-cli/releases/tag/v0.3.0";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
