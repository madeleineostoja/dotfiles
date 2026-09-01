#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

nixfmt --check flake.nix home.nix modules/*.nix
nix eval --no-write-lock-file .#homeConfigurations.mads.activationPackage.drvPath >/dev/null

while IFS= read -r file; do
  bash -n "$file"
  shellcheck "$file"
done < <(fd -H -t f -e sh scripts; printf '%s\n' .githooks/pre-commit)

while IFS= read -r file; do
  jq empty "$file"
done < <(fd -H -t f -e json configs)

while IFS= read -r file; do
  plutil -lint "$file"
done < <(fd -H -t f -e plist .)

if git grep -InE '[[:blank:]]+$' -- .; then
  printf 'Error: trailing whitespace found.\n' >&2
  exit 1
fi
