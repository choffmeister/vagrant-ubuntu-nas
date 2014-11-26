#!/bin/bash

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

exit 0
