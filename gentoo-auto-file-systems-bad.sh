#!/bin/bash
echo "what disk?"
read disk
ram=$(vmstat -s -S M | grep "total memory" | egrep -o '[0-9.]+')
ram="+$ram""MB"
fdisk /dev/"$disk" <<EEOF
g
#efi boot part
n


+1g
y
t
1

#swap part
n
2

$ram
y
t

19
#root part
n
3


y
t

23
#
p
w
EEOF
mkfs.xfs /dev/nvme0n1p3
mkfs.vfat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2 
mount /dev/nvme0n1p3 /mnt/gentoo
mkdir /mnt/gentoo/efi
mount /dev/nvme0n1p1 /mnt/gentoo/efi
swapon /dev/nvme0n1p2
