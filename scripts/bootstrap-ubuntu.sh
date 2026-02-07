#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  tmux micro nnn \
  git openssh-client sshfs rsync jq unzip zip less nano vim \
  ca-certificates curl wget

# Micro config
mkdir -p "$HOME/.config/micro"
if [ -d "$HOME/dotfiles/micro" ]; then
  rsync -a "$HOME/dotfiles/micro/" "$HOME/.config/micro/"
fi

# tmux config
if [ -f "$HOME/dotfiles/tmux/.tmux.conf" ]; then
  cp "$HOME/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

# Make micro your default editor
if ! grep -q 'export EDITOR="micro"' "$HOME/.bashrc" 2>/dev/null; then
  echo 'export EDITOR="micro"' >> "$HOME/.bashrc"
fi

echo "✅ Done. Restart shell or run: source ~/.bashrc"
echo "Try: tmux   |   micro   |   nnn"
