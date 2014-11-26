#!/bin/bash

case "$1" in
  start)
    echo "Starting my Ipsec VPN"
    iptables -t nat -A POSTROUTING -o eth0 -s %SERVER_IP%/24 -j MASQUERADE
    echo 1 > /proc/sys/net/ipv4/ip_forward
    for each in /proc/sys/net/ipv4/conf/*
    do
      echo 0 > $each/accept_redirects
      echo 0 > $each/send_redirects
    done
    /etc/init.d/ipsec start
    /etc/init.d/xl2tpd start
    ;;
  stop)
    echo "Stopping my Ipsec VPN"
    iptables --table nat --flush
    echo 0 > /proc/sys/net/ipv4/ip_forward
    /etc/init.d/ipsec stop
    /etc/init.d/xl2tpd stop
    ;;
  restart)
    echo "Restarting my Ipsec VPN"
    iptables -t nat -A POSTROUTING -o eth0 -s %SERVER_IP%/24 -j MASQUERADE
    echo 1 > /proc/sys/net/ipv4/ip_forward
    for each in /proc/sys/net/ipv4/conf/*
    do
      echo 0 > $each/accept_redirects
      echo 0 > $each/send_redirects
    done
    /etc/init.d/ipsec restart
    /etc/init.d/xl2tpd restart
    ;;
  *)
    echo "Usage: /etc/init.d/vpn {start|stop|restart}"
    exit 1
    ;;
esac
