#!/bin/bash

# prepare
apt-get update
apt-get install -y aptitude

# create raid
apt-get install -y mdadm
devs="/dev/sdb /dev/sdc /dev/sdd"
i=1
for dev in $devs; do
  parted -s -- "${dev}" mklabel gpt
  parted -a optimal -s -- "${dev}" mkpart primary 2048s -8192s
  parted -s -- "${dev}" set 1 raid on
  i=$((i+1))
done
mdadm --create /dev/md0 --auto md --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
mkfs.ext4 /dev/md0
mkdir -p /mnt/data
echo "/dev/md0 /mnt/data ext4 defaults 0 2" >> /etc/fstab
/usr/share/mdadm/mkconf > /etc/mdadm/mdadm.conf
mount /mnt/data

# create homes folder
mkdir -p /mnt/data/homes
mv /home/* /mnt/data/homes
echo "/mnt/data/homes /home none bind 0 0" >> /etc/fstab
mount /home

# create media folder
mkdir -p /mnt/data/media
chmod -R 2770 /mnt/data/media
chown root:users /mnt/data/media

# install samba
apt-get install -y samba-common samba
cp /vagrant/conf/smb.conf /etc/samba/smb.conf
service samba restart

exit 0
