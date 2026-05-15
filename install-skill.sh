#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <target-directory>" >&2
}

if [ "$#" -ne 1 ]; then
  usage
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/bring"
TARGET_ROOT="$1"
TARGET_DIR="$TARGET_ROOT/bring"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: source directory not found: $SOURCE_DIR" >&2
  exit 1
fi

if [ ! -d "$TARGET_ROOT" ]; then
  echo "Error: target directory does not exist: $TARGET_ROOT" >&2
  exit 1
fi

if [ -e "$TARGET_DIR" ]; then
  if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: target path exists but is not a directory: $TARGET_DIR" >&2
    exit 1
  fi

  printf "Target directory already exists: %s\nRemove it before copying? [y/N] " "$TARGET_DIR" >&2
  read -r answer
  case "$answer" in
    y|Y|yes|YES)
      rm -rf "$TARGET_DIR"
      ;;
    *)
      echo "Install cancelled." >&2
      exit 1
      ;;
  esac
fi

cp -R "$SOURCE_DIR" "$TARGET_ROOT/"
echo "Installed bring skill to $TARGET_DIR"
