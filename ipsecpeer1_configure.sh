#!/bin/bash

peer1_user_net="$(echo $ipsecpeer1_private2 | awk -F "." '{OFS = ".";}{print $1,$2,$3,"0/24"}')"
peer2_user_net="$(echo $private | awk -F "." '{OFS = ".";}{print $1,$2,$3,"0/24"}')"
wan_side_port="$(ifconfig | grep -B 1 $softfire_internal | head -1 | awk {'print($1)'})"
dhclient -v $wan_side_port

#enable ipv4 forwarding
sysctl -w net.ipv4.ip_forward=1

#generate ipsec.conf

echo "config setup
   uniqueids = never

conn %default
   ikelifetime=60m
   keylife=20m
   rekeymargin=3m
   keyingtries=1
   authby=secret
   keyexchange=ikev2
   mobike=no

conn net-net
   left=$ipsecpeer1_softfire_internal_floatingIp
   leftid=@moon.strongswan.org
   leftsubnet=$peer1_user_net
   leftfirewall=yes
   right=$softfire_internal
   rightsubnet=$peer2_user_net
   rightid=@sun.strongswan.org
   auto=start" > ipsec.conf

echo "# /etc/ipsec.secrets - strongSwan IPsec secrets file
@moon.strongswan.org @sun.strongswan.org : PSK 0sv+NkxY9LLZvwj4qCC2o/gGrWDF2d21jL" > /etc/ipsec.secrets

echo "listing file ipsec.conf:"
cat ipsec.conf

ipsec stop
ipsec start --conf ipsec.conf

