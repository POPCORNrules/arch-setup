#!/bin/bash
pacman -Sy --noconfirm pacman-contrib
curl -s "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors - > /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware intel-ucode xorg lightdm lightdm-webkit2-greeter dialog netctl iw dhcpcd wpa_supplicant inetutils awesome openssh git nano termite alsa-utils pacman-contrib acpid pavucontrol udisks2 light lxappearance unzip ranger atool w3m poppler mediainfo
genfstab -U /mnt > /mnt/etc/fstab
curl -SsL https://raw.githubusercontent.com/POPCORNrules/arch-setup/master/stage-2.sh -o /mnt/root/stage-2.sh
chmod +x /mnt/root/stage-2.sh
clear
echo 'run stage 2 from arch-chroot ./stage-2.sh <user> <hostname>'