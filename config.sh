export MKSWAP=0
export MUSL=1
export LUKSROOT=0

##    if set to 1 format fileystem 
export FORMAT=0

export ROOTLUKS="tank"
export DATALUKS="data"

#export BTRFS_OPTS="rw,noatime,compress=zstd,space_cache"
### removed space_cache for incompatibility with btrfstools 5.15 and higher
export BTRFS_OPTS="rw,noatime,compress=zstd"

export INTERFACE="eno1"

export HOSTNAME="localhost"
export TIMEZONE="Europe/Rome"
export KEYMAP="it"

export # Packages

export ## repo-fi bug close connections after some downloads
export #REPO="http://repo-fi.voidlinux.org"
export REPO="http://alpha.de.repo.voidlinux.org"
if [ "$MUSL" -eq 1 ]; then
	export REPOS="void-repo-nonfree"
else
	export REPOS="void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree"
fi

export DE="xorg xinit"
export DE_EXTRAS="pinentry-gtk greybird-themes firefox mpv sxiv"

export SHELL="bash"

export DEVELOPMENT="base-devel git emacs vim"

export PACKAGES="tmux mpd ncmpcpp gnupg2 curl vpsm rsync "
export #PACKAGES+=" pulseaudio zip unzip font-iosevka feh python dunst aerc htop ripgrep picom"
export PACKAGES+=" pulseaudio zip unzip font-iosevka feh dunst aerc htop ripgrep picom"
export PACKAGES+=" keychain wireguard bash-completion ModemManager screen wpa_gui hostapd dnsmasq socklog socklog-void iperf3 neofetch powertop arp-scan iptraf-ng iftop tcpdump"
export PACKAGES+=" ${DE} ${DE_EXTRAS} ${SHELL} ${DEVELOPMENT}"
