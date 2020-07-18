#!/bin/bash
sudo wifi-menu
ip link | sudo awk '/wl/{system("systemctl enable netctl-auto@"substr($2, 1, length($2)-1))}'
sudo systemctl start bluetooth
sudo systemctl enable bluetooth
if [ "$#" -eq 1 ]
    $DOTFILES=$1
    yadm clone --bootstrap "$DOTFILES"
fi