#!/bin/bash
# cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# awk '/^## United States$/{f=1; next}f==0{next}/^$/{exit}{print substr($0, 1);}' /etc/pacman.d/mirrorlist.backup
# rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
pacman -Sy --noconfirm pacman-contrib
curl -s "https://www.archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors - > /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware intel-ucode xorg lightdm lightdm-webkit2-greeter dialog netctl iw dhcpcd wpa_supplicant inetutils awesome openssh git nano termite ttf-dejavu pulseaudio alsa-utils pacman-contrib acpid pavucontrol udisks2
genfstab -U /mnt > /mnt/etc/fstab
curl -SsL https://raw.githubusercontent.com/POPCORNrules/arch-setup/master/stage-2.sh -o /mnt/root/stage-2.sh
chmod +x /mnt/root/stage-2.sh
clear
echo 'run stage 2 from arch-chroot ./stage-2.sh <user> <hostname>'