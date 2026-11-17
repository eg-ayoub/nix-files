# Points each image in modules/services/container-images.json at the digest its tag has now.
# The digest is that of the multi-arch index; podman picks the image for the host from it.
{ pkgs }:
pkgs.writeShellApplication {
  name = "update-images";
  runtimeInputs = [
    pkgs.crane
    pkgs.jq
  ];
  text = ''
    # usage: update-images [file], from the repository root
    file=''${1:-modules/services/container-images.json}
    mapfile -t names < <(jq -r 'keys[]' "$file")
    for name in "''${names[@]}"; do
      ref=$(jq -r --arg name "$name" '.[$name] | "\(.repo):\(.tag)"' "$file")
      digest=$(crane digest "$ref")
      updated=$(jq --arg name "$name" --arg digest "$digest" '.[$name].digest = $digest' "$file")
      printf '%s\n' "$updated" > "$file"
      echo "$name: $digest"
    done
  '';
}
