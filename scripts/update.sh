#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${HOME}/dotfiles"

[[ -d "$REPO_DIR/.git" ]] || {
  printf 'Error: expected dotfiles repository at %s\n' "$REPO_DIR" >&2
  exit 1
}

start_time=$(date +%s)
printf 'System update — %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')"

printf '▶ Updating Homebrew metadata...\n'
brew update
printf '▶ Upgrading Homebrew packages...\n'
brew upgrade --yes
printf '▶ Upgrading Mac App Store apps...\n'
mas upgrade
printf '▶ Reconciling applications...\n'
"$REPO_DIR/scripts/appsync.sh"

printf '▶ Updating Nix inputs...\n'
nix flake update --flake "$REPO_DIR"
printf '▶ Applying Home Manager...\n'
home-manager switch --flake "$REPO_DIR"

printf '▶ Installing mise tools...\n'
(
  cd "$HOME"
  mise install
)
printf '▶ Upgrading mise tools...\n'
(
  cd "$HOME"
  mise upgrade
)

printf '▶ Optimising the Nix store...\n'
nix store optimise || printf 'Warning: Nix store optimisation failed; continuing.\n' >&2

end_time=$(date +%s)
printf '\nDone in %ss.\n\n' "$((end_time - start_time))"
printf 'Review and commit:\n  cd ~/dotfiles && git diff flake.nix flake.lock\n'
printf "If anything broke: home-manager switch --rollback\n"
