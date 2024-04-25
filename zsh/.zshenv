#!/bin/sh
export PATH="/home/eric/.local/bin:$PATH"
export EDITOR="nvim"

export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_PICTURES_DIR="$HOME/pictures"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

export GRIM_DEFAULT_DIR="$HOME/pictures"
export PYTHONPATH="${PYTHONPATH}:/home/eric/documents/deep_learning/CNN"
export GPG_TTY=$(tty)

export MOZ_ENABLE_WAYLAND=1 firefox
export MOZ_USE_XINPUT2=1

export R_LIBS_USER=${XDG_DATA_HOME:-$HOME/.local/share}/R/%p-library/%v
export R_PROFILE_USER=${XDG_CONFIG_HOME:-$HOME/.config}/R/rprofile
export R_ENVIRON_USER=${XDG_CONFIG_HOME:-$HOME/.config}/R/renviron
