#!/bin/bash

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
/usr/share/mdadm/mkconf > /etc/mdadm/mdadm.conf
mkdir -p /mnt/data

read -p "Do you want to encrypt the raid (yes/no)? "
if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]
then
  apt-get install -y cryptsetup
  modprobe dm-crypt
  cryptsetup luksFormat -c aes-xts-plain64 -s 256 -h sha256 -y /dev/md0
  cryptsetup luksOpen /dev/md0 md0-crypt
  mkfs.ext4 /dev/mapper/md0-crypt
  echo "/dev/mapper/md0-crypt /mnt/data ext4 defaults,noauto 0 2" >> /etc/fstab
  mount /mnt/data
else
  mkfs.ext4 /dev/md0
  echo "/dev/md0 /mnt/data ext4 defaults 0 2" >> /etc/fstab
  mount /mnt/data
fi

# create homes folder
mkdir -p /mnt/data/homes
mv /home/* /mnt/data/homes
echo "/mnt/data/homes /home none bind 0 0" >> /etc/fstab
mount /home

# create media folder
mkdir -p /mnt/data/media
chmod -R 2770 /mnt/data/media
chown root:users /mnt/data/media

read -p "Do you want to install Samba server (yes/no)? "
if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]
then
  # install samba
  apt-get install -y samba-common samba
  cat /vagrant/conf/samba/smb.conf > /etc/samba/smb.conf
  service samba restart
fi

read -p "Do you want to install Plex Media Server (yes/no)? "
if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]
then
  apt-get install -y avahi-daemon avahi-utils
  wget --quiet --output-document /tmp/plexmediaserver.deb "https://downloads.plex.tv/plex-media-server/0.9.11.1.678-c48ffd2/plexmediaserver_0.9.11.1.678-c48ffd2_amd64.deb"
  dpkg -i /tmp/plexmediaserver.deb
  usermod -aG users plex
fi

read -p "Do you want to install L2TP/IPSec VPN server (yes/no)? "
if [[ $REPLY =~ ^[Yy]([Ee][Ss])?$ ]]
then
  SERVER_IP="10.0.23.5" #$(curl --silent http://ip.mtak.nl)
  SHARED_SECRET=$(openssl rand -hex 30)

  # install l2tp/ipsec server
  apt-get install -y openswan xl2tpd ppp lsof
  sleep 5
  service ipsec stop
  service xl2tpd stop
  update-rc.d ipsec disable
  update-rc.d xl2tpd disable

  # configure vpn security
  sed "s/%SERVER_IP%/${SERVER_IP}/" /vagrant/conf/l2tp-ipsec/ipsec.conf > /etc/ipsec.conf
  echo "${SERVER_IP}  %any:   PSK \"${SHARED_SECRET}\"" >> /etc/ipsec.secrets
  cat /vagrant/conf/l2tp-ipsec/xl2tpd.conf > /etc/xl2tpd/xl2tpd.conf
  cat /vagrant/conf/l2tp-ipsec/ppp > /etc/pam.d/ppp
  echo '*       l2tpd           ""              *' >> /etc/ppp/pap-secrets
  cat /vagrant/conf/l2tp-ipsec/options.xl2tpd > /etc/ppp/options.xl2tpd

  # create vpn init script
  sed "s/%SERVER_IP%/${SERVER_IP}/" /vagrant/conf/l2tp-ipsec/init-script.sh > /etc/init.d/vpn
  chmod +x /etc/init.d/vpn
  update-rc.d vpn defaults
  service vpn start

  sleep 3
  ipsec verify
fi

exit 0
