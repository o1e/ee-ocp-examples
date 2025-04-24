#!/usr/bin/env bash
set -euo pipefail

echo "Installing additional CLI tools ..."

# URLs of the archives to download
declare -A ARCHIVES=(
  [oc_tools]="https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz"
  [helm]="https://get.helm.sh/helm-v3.17.2-linux-amd64.tar.gz"
  [vault]="https://releases.hashicorp.com/vault/1.15.5/vault_1.15.5_linux_amd64.zip"
  [tekton]="https://mirror.openshift.com/pub/openshift-v4/clients/pipeline/latest/tkn-linux-amd64.tar.gz"
)

# Files to extract from each archive
declare -A FILES_TO_EXTRACT=(
  [oc_tools]="oc kubectl"
  [helm]="linux-amd64/helm"
  [vault]="vault"
  [tekton]="tkn"
)

WORKDIR="$(mktemp -d)"
echo "Working directory: $WORKDIR"

for name in "${!ARCHIVES[@]}"; do
  url="${ARCHIVES[$name]}"
  files="${FILES_TO_EXTRACT[$name]}"
  archive_path="$WORKDIR/${name}$(basename "$url" | sed 's/.*\(\.zip\|\.tar\.gz\)$//')"
  archive_path="$WORKDIR/$name${url##*/}"
  extract_dir="$WORKDIR/$name"

  echo "Downloading $name from $url ..."
  curl -sSL "$url" -o "$archive_path"

  echo "Extracting $name ..."
  mkdir -p "$extract_dir"
  case "$archive_path" in
    *.zip)
      unzip -q "$archive_path" -d "$extract_dir"
      ;;
    *.tar.gz)
      tar -xzf "$archive_path" -C "$extract_dir"
      ;;
    *)
      echo "Error: unsupported archive format for $archive_path"
      exit 1
      ;;
  esac

  for file in $files; do
    src_path="$extract_dir/$file"
    target_name="$(basename "$file")"
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

