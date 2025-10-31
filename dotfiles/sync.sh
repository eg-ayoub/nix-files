#!/usr/bin/env bash

# check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "stow is not installed. Please install it first."
    exit 1
fi

_ignore() {
    echo "!! Ignoring $1"
}

_process() {
    echo "-> Stowing $1"
    stow "$1" -t "$HOME" --dotfiles --no-folding --restow
}

modules=(
    "nvim"
    "scripts"
    "kitty"
    "qtile"
    "niri"
)

# if arguments have been passed, check if they're part of modules,
# if not, skip them,
# if they are, stow them
for module in "$@"; do
    if printf '%s\0' "${modules[@]}" | grep -Fxqz "$module"; then
        _process "$module"
    else
        _ignore "$module"
    fi
done
