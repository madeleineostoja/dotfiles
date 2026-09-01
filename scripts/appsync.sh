#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

brew bundle install --force-cleanup --force --zap --file="$REPO_DIR/Brewfile"
brew cleanup --prune=all
