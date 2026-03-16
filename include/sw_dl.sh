#!/usr/bin/env bash
set -euo pipefail

echo "Installing additional CLI tools ..."

# ---------------------------------------------------------
# Resolve latest Helm version via GitHub API
# ---------------------------------------------------------
echo "Resolving latest Helm version ..."
HELM_VERSION="$(
  curl -fsSL https://api.github.com/repos/helm/helm/releases/latest \
  | grep tag_name \
  | cut -d '"' -f4
)"

if [[ -z "$HELM_VERSION" ]]; then
  echo "Error: Could not determine latest Helm version"
  exit 1
fi

echo "Latest Helm version: $HELM_VERSION"

# URLs of the archives to download
declare -A ARCHIVES=(
  [oc_tools]="https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz"
  [helm]="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"
  [tekton]="https://mirror.openshift.com/pub/openshift-v4/clients/pipeline/latest/tkn-linux-amd64.tar.gz"
)

# Files to extract from each archive
declare -A FILES_TO_EXTRACT=(
  [oc_tools]="oc kubectl"
  [helm]="linux-amd64/helm"
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
      tar --no-same-owner -xzf "$archive_path" -C "$extract_dir"
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

