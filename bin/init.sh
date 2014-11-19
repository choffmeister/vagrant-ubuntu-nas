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
  mkdir -p "/mnt/data${i}"
  mount "${dev}1" "/mnt/data${i}"

  i=$((i+1))
done

exit 0
