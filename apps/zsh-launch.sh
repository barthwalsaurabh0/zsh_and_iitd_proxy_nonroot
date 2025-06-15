#!/bin/bash
export LD_LIBRARY_PATH="$HOME/apps/ncurses/lib:$LD_LIBRARY_PATH"
exec "$HOME/apps/zsh/bin/zsh"
