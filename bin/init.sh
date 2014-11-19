#!/bin/bash

# prepare
apt-get update
apt-get install -y aptitude

# format disks
devs="/dev/sdb /dev/sdc /dev/sdd"
i=1
for dev in $devs; do
  echo -e "d\nn\n\n\n\n\nw\nY\n" | gdisk "${dev}"
  mkfs.ext4 "${dev}1"

  uuid=$(blkid "${dev}1" | sed 's/.*UUID="\([^"]*\)".*/\1/')
  mkdir -p "/mnt/data${i}"
  echo "UUID=${uuid} /mnt/data${i} ext4 defaults 0 2" >> /etc/fstab

  i=$((i+1))
done

# create merged disk
aptitude install -y mhddfs
mkdir -p /mnt/data
echo "mhddfs#/mnt/data1,/mnt/data2,/mnt/data3 /mnt/data fuse defaults,allow_other,nofail,noauto 0 0" >> /etc/fstab

exit 0
