#!/usr/bin/env bash
set -uo pipefail

LAST_RUN_FILE="$HOME/.local/state/nix-gc-last-run"
WEEK_SECONDS=$((7 * 24 * 60 * 60))
LOG_FILE="/tmp/nix-gc.log"

mkdir -p "$(dirname "$LAST_RUN_FILE")"

LAST_RUN=$(cat "$LAST_RUN_FILE" 2>/dev/null || echo 0)
NOW=$(date +%s)

if (( NOW - LAST_RUN < WEEK_SECONDS )); then
  echo "$(date '+%Y-%m-%d %H:%M:%S') GC skipped — last run was within 7 days" >> "$LOG_FILE"
  exit 0
fi

{
  echo "=== nix-gc.sh starting at $(date '+%Y-%m-%d %H:%M:%S') ==="

  if ! command -v nix >/dev/null 2>&1; then
    echo "nix not found in PATH; exiting"
    exit 0
  fi

  echo "Running nix-collect-garbage..."
  nix-collect-garbage --delete-older-than 30d

  echo "Running nix store optimise..."
  nix store optimise

  echo "=== Done at $(date '+%Y-%m-%d %H:%M:%S') ==="
} >> "$LOG_FILE" 2>&1

date +%s > "$LAST_RUN_FILE"
