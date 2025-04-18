#!/usr/bin/env bash
set -euo pipefail

echo "Installing additional CLI tools ..."

# URLs of the archives to download
declare -A ARCHIVES=(
  [oc_tools]="https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz"
  [helm]="https://get.helm.sh/helm-v3.17.2-linux-amd64.tar.gz"
)

# Which files to extract from each archive
declare -A FILES_TO_EXTRACT=(
  [oc_tools]="oc kubectl"
  [helm]="linux-amd64/helm"
)

WORKDIR=$(mktemp -d)
echo "Working directory: $WORKDIR"

# Download and extract each archive
for name in "${!ARCHIVES[@]}"; do
  url="${ARCHIVES[$name]}"
  files="${FILES_TO_EXTRACT[$name]}"
  archive_path="$WORKDIR/$name.tar.gz"
  extract_dir="$WORKDIR/$name"

  echo "Downloading $name from $url ..."
  curl -sSL "$url" -o "$archive_path"

  echo "Extracting $name ..."
  mkdir -p "$extract_dir"
  tar -xzf "$archive_path" -C "$extract_dir"

  # Install selected files to /usr/local/bin
  for file in $files; do
    src_path="$extract_dir/$file"
    target_name=$(basename "$file")
    target_path="/usr/local/bin/$target_name"

    if [[ -f "$src_path" ]]; then
      echo "Installing $target_name to $target_path"
      install -m 755 "$src_path" "$target_path"
    else
      echo "Error: $src_path not found!"
      exit 1
    fi
  done
done

echo "Cleaning up temporary files ..."
rm -rf "$WORKDIR"

echo "Tool installation complete."

