#!/bin/bash

# prepare
apt-get update
apt-get install -y aptitude

# format disks
devs="/dev/sdb /dev/sdc /dev/sdd"
i=1
for dev in $devs; do
  parted -s -- "${dev}" mklabel gpt
  parted -a optimal -s -- "${dev}" mkpart primary 2048s -8192s
  mkfs.ext4 "${dev}1"

  uuid=$(blkid "${dev}1" | sed 's/.*UUID="\([^"]*\)".*/\1/')
  mkdir -p "/mnt/data${i}"
  echo "UUID=${uuid} /mnt/data${i} ext4 defaults 0 2" >> /etc/fstab
  mount "/mnt/data${i}"

  i=$((i+1))
done

# create merged disk
aptitude install -y mhddfs
mkdir -p /mnt/data
echo "mhddfs#/mnt/data1,/mnt/data2,/mnt/data3 /mnt/data fuse defaults,allow_other,nofail 0 0" >> /etc/fstab
mount /mnt/data

# create homes folder
mkdir -p /mnt/data/homes
mv /home/* /mnt/data/homes
echo "/mnt/data/homes /home none bind 0 0" >> /etc/fstab
mount /home

# create media folder
mkdir -p /mnt/data/media
mkdir -p /mnt/data/media/movies
mkdir -p /mnt/data/media/tvshows
chown -R nobody:users /mnt/data/media
chmod -R 0770 /mnt/data/media/*

# install samba
apt-get install -y samba-common samba
cp /vagrant/conf/smb.conf /etc/samba/smb.conf
service samba restart

# install plex server
apt-get install -y avahi-daemon avahi-utils
wget --quiet --output-document /tmp/plexmediaserver.deb "https://downloads.plex.tv/plex-media-server/0.9.11.1.678-c48ffd2/plexmediaserver_0.9.11.1.678-c48ffd2_amd64.deb"
dpkg -i /tmp/plexmediaserver.deb
usermod -aG users plex

exit 0
