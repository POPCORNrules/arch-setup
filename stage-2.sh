#!/bin/bash
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -ge 1 ] || die "at least one argument is needed"
USERNAME=$1
HOSTNAME=${2:-$1-archlinux}
echo "user:\t $1\nhostname:${2:-$1-archlinux}"
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo $HOSTNAME > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$HOSTNAME.localdomain\t$HOSTNAME" >> /etc/hosts
echo -e 'ENV{ID_FS_USAGE}=="filesystem|other|crypto",ENV{UDISKS_FILESYSTEM_SHARED}="1"' > /etc/udev/rules.d/99-udisks2.rules
echo -e 'D /media 0755 root root 0 -' > /etc/tmpfiles.d/media.conf
mkdir /media
clear
echo Set root password
passwd
bootctl install
echo default arch-* > /boot/loader/loader.conf
echo title Arch Linux > /boot/loader/entries/arch.conf
echo linux /vmlinuz-linux >> /boot/loader/entries/arch.conf
echo initrd /intel-ucode.img >> /boot/loader/entries/arch.conf
echo initrd /initramfs-linux.img >> /boot/loader/entries/arch.conf
awk '$2~"^/$"{print option "options root="$1" rw"}' /etc/fstab >> /boot/loader/entries/arch.conf
systemctl enable lightdm
systemctl enable acpid
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/00-wheel
useradd -m -G wheel,video $USERNAME
clear
echo Set user password
passwd $USERNAME
cd /home/$USERNAME
runuser -u $USERNAME -- git clone https://aur.archlinux.org/yay.git .src/yay
cd .src/yay
runuser -u $USERNAME -- makepkg -si
cd ../..
rm -rf .src/yay
runuser -u $USERNAME -- yay -Sy yadm lightdm-webkit-theme-aether-git bashmount
sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = lightdm-webkit-theme-aether/g' /etc/lightdm/lightdm-webkit2-greeter.conf
sed -i 's/^\(#\?greeter\)-session\s*=\s*\(.*\)/greeter-session = lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf
curl -SsL https://raw.githubusercontent.com/POPCORNrules/arch-setup/master/stage-3.sh -o /home/$USERNAME/stage-3.sh
chown $USERNAME:$USERNAME /home/$USERNAME/stage-3.sh