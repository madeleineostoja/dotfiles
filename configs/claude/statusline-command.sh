#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten home directory to ~
home="$HOME"
short_cwd="${cwd/#$home/\~}"

# Get git branch (skip optional locks)
branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)

# Build each segment
dir_part=$(printf '\033[34m%s\033[0m' "$short_cwd")

if [ -n "$branch" ]; then
  git_part=$(printf ' \033[35m(%s)\033[0m' "$branch")
else
  git_part=""
fi

if [ -n "$model" ]; then
  model_part=$(printf ' \033[36m%s\033[0m' "$model")
else
  model_part=""
fi

if [ -n "$used" ]; then
  ctx_part=$(printf ' \033[33mctx:%.0f%%\033[0m' "$used")
else
  ctx_part=""
fi

printf '%b%b%b%b' "$dir_part" "$git_part" "$model_part" "$ctx_part"
