#!/bin/bash
sudo wifi-menu
ip link | sudo awk '/wl/{system("systemctl enable netctl-auto@"substr($2, 1, length($2)-1))}'
if [ "$#" -eq 1 ]
    $DOTFILES=$1
    yadm clone --bootstrap "$DOTFILES"
fi