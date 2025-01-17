#!/bin/bash

set -x

RDISK=$1
ROOT=$2
BOOT=$3
DATA=$4
USR=$5

source config.sh

dhcpcd $INTERFACE

chown root:root /
chmod 755 /

# disable copy on write for the vms folder
if [[ $DATA != "" ]]; then
    chattr +C /mnt/vault/vms
fi

echo "Setting timezone to ${TIMEZONE}"
ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

ntpdate -s time.nist.gov

echo "Setting hostname to ${HOSTNAME}"
echo "${HOSTNAME}" > /etc/hostname

echo "Creating user: ${USR}"
useradd -u 2345 -m -G wheel,floppy,audio,video,optical,cdrom -s /bin/bash "$USR"
pwconv

echo "Changing password for ${USR}"
passwd "$USR"

echo "Changing password for root"
passwd root

sed -i.bak -E \
  "/%wheel ALL=\(ALL\) ALL/s/^#[[:space:]]//g" \
  /mnt/etc/sudoers


if [[ $MUSL -eq 0 ]] ;then
	echo "LANG=en_US.UTF-8" > /etc/locale.conf
	echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
	xbps-reconfigure -f glibc-locales
fi

# setup fstab
echo "Setting up /etc/fstab"

root_uuid=$(blkid "$ROOT" --output export | grep "^UUID=" | cut -d ' ' -f 2 | tr -d ' ')
boot_uuid=$(blkid "$BOOT" --output export | grep "^UUID=" | cut -d ' ' -f 2 | tr -d ' ')

echo "${root_uuid}  / btrfs  $BTRFS_OPTS,subvol=@ 0 1" > /etc/fstab
echo "${root_uuid}  /home btrfs  $BTRFS_OPTS,subvol=@home 0 1" >> /etc/fstab
echo "${boot_uuid}  /boot  vfat  rw,relatime  0 0" >> /etc/fstab

if [[ $DATA != "" ]]; then
    data_uuid=$(blkid "$DATA" --output export | grep "^UUID=" | cut -d ' ' -f 2 | tr -d ' ')
    echo "${data_uuid}  /mnt/vault  btrfs $BTRFS_OPTS,subvol=@vault  0 1" >> /etc/fstab
    echo "${data_uuid}  /mnt/snapshots btrfs  $BTRFS_OPTS,subvol=@snapshots 0 1" >> /etc/fstab
    echo "data ${data_uuid} /root/data.key" > /etc/crypttab
fi

echo "tmpfs  /tmp  tmpfs  defaults,nosuid,nodev  0 0" >> /etc/fstab

echo "Setting up /etc/rc.conf"
echo "TIMEZONE=${TIMEZONE}" > /etc/rc.conf
echo "KEYMAP=${KEYMAP}" >> /etc/rc.conf

# install and configure refind
refind-install
echo "\"Boot with standard options\" \"root=${root_uuid} rootflags=subvol=@ rw quiet initrd=/initramfs-%v.img rd.auto=1 init=/sbin/init vconsole.unicode=1 vconsole.keymap=${KEYMAP}\"" > /boot/refind_linux.conf

# setup extra repos
xbps-install -Sy "$REPOS"

# change mirror to one in the united states
mkdir -p /etc/xbps.d/
cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
sed -i "s|https://alpha.de.repo.voidlinux.org|$REPO|g" /etc/xbps.d/*-repository-*.conf

echo "update all installed packages "
xbps-install -Syu
echo "install packages "
printf "install -Sy %s \n" "$PACKAGES"
xbps-install -v -d -Sy "$PACKAGES"

kickstart_script_url=https://github.com/littlewing7/mma-install-scripts/blob/master/kickstart/kickstart-void.sh

if [ -n "${kickstart_script_url}" ]; then
    say "Downloading kickstart script to user's home directory"
    wget ${kickstart_script_url} -O /mnt/home/${user}/kickstart.sh
    chroot_run chown ${user}:${user} /home/${user}/kickstart.sh
    chroot_run chmod +x /home/${user}/kickstart.sh
fi


printf "exit chroot \n"
