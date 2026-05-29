#!/usr/bin/env bash
set -uo pipefail

REPO_DIR="${HOME}/dotfiles"

latest_common_release() {
  local tmpdir latest

  tmpdir=$(mktemp -d) || return 1

  git ls-remote --heads https://github.com/NixOS/nixpkgs.git 'refs/heads/nixpkgs-*-darwin' \
    | sed -n 's|.*refs/heads/nixpkgs-\([0-9][0-9]*\.[0-9][0-9]*\)-darwin$|\1|p' \
    | sort -u >"${tmpdir}/nixpkgs" \
    || { rm -rf "$tmpdir"; return 1; }

  git ls-remote --heads https://github.com/nix-community/home-manager.git 'refs/heads/release-*' \
    | sed -n 's|.*refs/heads/release-\([0-9][0-9]*\.[0-9][0-9]*\)$|\1|p' \
    | sort -u >"${tmpdir}/home-manager" \
    || { rm -rf "$tmpdir"; return 1; }

  latest=$(comm -12 "${tmpdir}/nixpkgs" "${tmpdir}/home-manager" | tail -n 1)
  rm -rf "$tmpdir"

  [ -n "$latest" ] || return 1
  printf '%s\n' "$latest"
}

update_flake_release_inputs() {
  local flake_file latest_release current_nixpkgs current_home_manager

  flake_file="${REPO_DIR}/flake.nix"
  latest_release=$(latest_common_release) || return 1

  current_nixpkgs=$(sed -n 's|.*nixpkgs.url = "github:NixOS/nixpkgs/\([^"]*\)";.*|\1|p' "$flake_file" | head -n 1)
  current_home_manager=$(sed -n 's|.*url = "github:nix-community/home-manager/\([^"]*\)";.*|\1|p' "$flake_file" | head -n 1)

  if [ "$current_nixpkgs" = "nixpkgs-${latest_release}-darwin" ] \
    && [ "$current_home_manager" = "release-${latest_release}" ]; then
    echo "▶ flake.nix release inputs already at ${latest_release}"
    return 0
  fi

  echo "▶ Updating flake.nix release inputs to ${latest_release}..."
  perl -0pi -e 's|nixpkgs\.url = "github:NixOS/nixpkgs/[^"]+";|nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-'"$latest_release"'-darwin";|' "$flake_file" \
    || return 1
  perl -0pi -e 's|url = "github:nix-community/home-manager(?:/[^"]*)?";|url = "github:nix-community/home-manager/release-'"$latest_release"'";|' "$flake_file" \
    || return 1
}

start_time=$(date +%s)
echo "🔄 System update — $(date '+%Y-%m-%d %H:%M:%S')"
echo

# --- Homebrew ---
echo "▶ brew update..."
brew update || { echo "❌ brew update failed"; exit 1; }

echo
echo "▶ Outdated:"
brew outdated || true

echo
echo "▶ brew upgrade..."
brew upgrade || echo "⚠️  some brew upgrades failed (continuing)"

echo
echo "▶ Reconciling Brewfile..."
brew bundle install --cleanup --force --zap --file="${REPO_DIR}/Brewfile" \
  || echo "⚠️  Brewfile reconcile had issues"

echo
echo "▶ brew cleanup..."
brew cleanup --prune=all

# --- Nix ---
if command -v nix >/dev/null 2>&1; then
  echo
  update_flake_release_inputs \
    || { echo "❌ flake.nix release input update failed"; exit 1; }

  echo
  echo "▶ nix flake update..."
  (cd "$REPO_DIR" && nix flake update) \
    || { echo "❌ nix flake update failed"; exit 1; }

  echo
  echo "▶ home-manager switch..."
  (cd "$REPO_DIR" && home-manager switch --flake .) \
    || { echo "❌ home-manager switch failed — try 'home-manager switch --rollback'"; exit 1; }

  # GC happens via launch agent; not duplicated here
fi

# --- mise ---
if command -v mise >/dev/null 2>&1; then
  echo
  echo "▶ mise plugin update..."
  mise plugin update || echo "⚠️  mise plugin update had issues"
fi

# --- pnpm globals ---
if command -v pnpm >/dev/null 2>&1; then
  echo
  echo "▶ pnpm update -g --latest..."
  pnpm update -g --latest || echo "⚠️  pnpm global update had issues"
fi

end_time=$(date +%s)
duration=$((end_time - start_time))
echo
echo "✅ Done in ${duration}s."
echo
echo "Review and commit:"
echo "  cd ~/dotfiles && git diff flake.nix flake.lock"
echo "If anything broke: home-manager switch --rollback"
