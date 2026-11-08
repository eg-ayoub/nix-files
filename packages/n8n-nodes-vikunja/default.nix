# n8n community node for Vikunja
# (https://github.com/go-vikunja/n8n-vikunja-nodes)
#
# Same approach as n8n-nodes-signal-cli: the upstream repo (and the published
# npm sdist) ship no package-lock.json, so we inject our own (./package-lock.json)
# in postPatch and pin its dependency closure via npmDepsHash. The package has no
# runtime dependencies of its own — the lockfile's closure is purely the
# `n8n-workflow` peer dependency — and upstream devDeps are irrelevant at install
# time, hence package.json is stripped of its devDependencies block. The sdist
# already contains a built dist/, so we skip `npm run build` (dontNpmBuild).
#
# To bump the version: update version/src hash, regenerate the lockfile
# (npm install --package-lock-only with devDependencies removed from
# package.json), then recompute npmDepsHash with
# `nix run nixpkgs#prefetch-npm-deps -- package-lock.json`.
{ pkgs, lib }:
pkgs.buildNpmPackage {
  pname = "n8n-nodes-vikunja";
  version = "0.4.1";

  src = pkgs.fetchurl {
    urls = [
      "https://registry.npmjs.org/n8n-nodes-vikunja/-/n8n-nodes-vikunja-0.4.1.tgz"
    ];
    hash = "sha256-VLwK/FBvW6/YnXy1NO+/Z1cxfqLwV1HUqKR4dHsvPbM=";
  };

  npmDepsHash = "sha256-UfkO4Me1veAwt4GI15NmRbdwzDGYlbxlbwqH3nPOTbc=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    sed -i -E '/"devDependencies": \{/,/^ *\}/d' package.json
  '';

  # dist/ is prebuilt in the sdist
  dontNpmBuild = true;

  meta = {
    description = "n8n community nodes for interacting with Vikunja";
    homepage = "https://github.com/go-vikunja/n8n-vikunja-nodes";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
