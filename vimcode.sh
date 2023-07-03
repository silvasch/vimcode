#!/bin/sh

if [ $# -eq 0 ]
then
    # print help
    exit
fi

if [ "$1" = "add" ];
then
    mkdir -p $HOME/.config/nvim/lua/config/plugins/pack/plugins/opt
    git submodule add "$2" "$HOME/.config/nvim/lua/config/plugins/pack/plugins/opt/$3"
elif [ "$1" = "rm" ];
then
    git submodule deinit -f "lua/config/plugins/pack/plugins/opt/$2"
    rm -rf "$HOME/.config/nvim/.git/modules/lua/config/plugins/pack/plugins/opt/$2"
    git rm -f "$HOME/.config/nvim/lua/config/plugins/pack/plugins/opt/$2"
else
    echo "Invalid subcommand"
fi
