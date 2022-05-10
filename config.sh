MKSWAP=0
MUSL=1
LUKS=0

ROOTLUKS="tank"
DATALUKS="data"

BTRFS_OPTS="rw,noatime,compress=zstd,space_cache"

INTERFACE="eno1"

HOSTNAME="localhost"
TIMEZONE="Europe/Rome"
KEYMAP="it"

# Packages

REPO="http://repo-fi.voidlinux.org"
REPOS="void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree"

DE="xorg xinit"
DE_EXTRAS="pinentry-gtk greybird-themes firefox mpv sxiv"

SHELL="bash"

DEVELOPMENT="base-devel git emacs vim"

PACKAGES="tmux mpd ncmpcpp gnupg2 curl vpsm rsync "
#PACKAGES+=" pulseaudio zip unzip font-iosevka feh python dunst aerc htop ripgrep picom"
PACKAGES+=" pulseaudio zip unzip font-iosevka feh dunst aerc htop ripgrep picom"
PACKAGES+=" ${DE} ${DE_EXTRAS} ${SHELL} ${DEVELOPMENT}"
