#!/usr/bin/env bash
set -veuo pipefail

SCRIPT_DIR=$(perl -MCwd=realpath -le 'print realpath shift' "$0/..")
PATH="$PATH:/opt/homebrew/bin"
PATH="$PATH:$HOME/.local/share/mise/installs/python/latest/bin"
PATH="$PATH:$HOME/.local/share/mise/installs/node/latest/bin"

function symlink_dir() {
    src=$1
    dst=$2
    [[ -L "$dst" ]] && rm -fr "$dst"
    ln -sf "$src" "$dst"
}


#
# Homebrew
#
if ! which brew; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

#
# Setup
#
mkdir -p $HOME/.config/
mkdir -p $HOME/workspace/apps/

#
# Brewfile
#
mkdir -p $HOME/.config/brew
ln -sf $SCRIPT_DIR/brew/Brewfile $HOME/.config/brew/.Brewfile
brew bundle --file=$HOME/.config/brew/.Brewfile

#
# Git
#
brew install git difftastic
symlink_dir $SCRIPT_DIR/git $HOME/.config/git

#
# mise
#
if [[ ! -e "$HOME/.local/bin/mise" ]]; then
    curl https://mise.run | sh
fi

#
# Ruby
#
if ! which node; then
    $HOME/.local/bin/mise use --global ruby
fi

#
# Java
#
if ! which java; then
    $HOME/.local/bin/mise use --global java
fi

#
# xcode
#
if ! xcode-select --print-path &> /dev/null; then
    xcode-select --install
fi

#
# Node
#
if ! which node; then
    $HOME/.local/bin/mise use --global node
fi

#
# Flutter
#
if ! which flutter; then
    $HOME/.local/bin/mise use --global flutter
fi

#
# Deno
#
if ! which deno; then
    $HOME/.local/bin/mise use --global deno
fi

#
# Python
#
brew install xz
if ! which python; then
    $HOME/.local/bin/mise use --global python
fi

#
# Rust
#
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y


#
# zsh
#
mkdir -p $HOME/.config/zsh
ln -sf $SCRIPT_DIR/zsh/zprofile $HOME/.zprofile
ln -sf $SCRIPT_DIR/zsh/zshenv $HOME/.zshenv
ln -sf $SCRIPT_DIR/zsh/zshrc $HOME/.zshrc
ln -sf $SCRIPT_DIR/zsh/p10k.zsh $HOME/.config/zsh/p10k.zsh
pip install requests # fzfのserverのために必要
zsh -i -c 'autoload -Uz compinit && compinit && compaudit | xargs chmod g-w'

#
# tmux
#
mkdir -p $HOME/.config/tmux
ln -sf $SCRIPT_DIR/tmux/tmux.conf $HOME/.config/tmux/tmux.conf

#
# ssh
#
mkdir -p $HOME/.ssh
ln -sf $SCRIPT_DIR/ssh/config $HOME/.ssh/config

