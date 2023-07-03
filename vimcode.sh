#!/bin/sh

if [ $# -eq 0 ]
then
    # print help
    exit
fi

if [ "$1" = "add" ];
then
    mkdir -p $HOME/.config/nvim/lua/config/plugins/site/pack/plugins/opt
    git submodule add "$2" lua/config/plugins/site/pack/plugins/opt
else
    echo "Invalid subcommand"
fi
