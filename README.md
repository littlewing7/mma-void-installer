
# forked from endoffile78/void-installer

this is a fork for Void-Linux installation with some changes: 

1. my personal list of Packages 
2. possibility to exclude LUKS crypt on ROOT FS 
3. Optionally setting MUSL libc installation instead of glibc in config.h
4. Optionally bypass disk format if the script fail for some reason to be able to investigate 
5. Fix fstab creation because it was incorrect if blkid return PARTUUID in addition to UUID 

# void-installer

Install script for Void Linux. This install script will create an encrypted install using btrfs and LUKS. You can optionally setup a data drive that is also encrypted. 

## Usage

1. Setup your internet connection.
2. Run:
```bash
./install <root disk> <data disk> <username>
```

Example:
```bash
./install /dev/sda /dev/sdb endoffile
```

If you do not want to setup a data drive then pass none instead. Example:
```bash
./install /dev/sda none endoffile
```

## Configuration

Included in this repo is a configuration file where you can change things such as the size of the partitions, timezone, keymap, etc. Below you can see the [defaults](#defaults).

<a href="#defaults"></a>
## Defaults
### Hard Drives

The following will be created on the btrfs partition on the root disk:

| name  | path  |
|-------|-------|
| @     | /     |
| @home | /home |

Subvolumes will also be created at /var/log /var/cache /var/tmp on the @
subvolume.

The following will be created on the btrfs partition on the data disk:

| name       | path           |
|------------|----------------|
| @snapshots | /mnt/snapshots |
| @vault     | /mnt/vault     |

Subvolumes will also be created at /mnt/vault/vms and /mnt/vault/storage
on the @vault subvolume.
