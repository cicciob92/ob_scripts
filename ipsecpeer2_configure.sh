#!/bin/bash

user_side_port="$(ifconfig | grep -B 1 $private2 | head -1 | awk {'print($1)'})"
wan_side_port="$(ifconfig | grep -B 1 $altra | head -1 | awk {'print($1)'})"
user_net="$(echo $private2 | awk -F "." '{OFS = ".";}{print $1,$2,$3,"0/24"}')"
external_net="$(echo $altra | awk -F "." '{OFS = ".";}{print $1,$2,$3,"0/24"}')"

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
   left=$altra
   leftid=@moon.strongswan.org
   leftsubnet=$user_net
   leftfirewall=yes
   right=$ipsec_peer2_altra
   rightsubnet=$external_net
   rightid=@sun.strongswan.org
   auto=start" > ipsec.conf


ipsec start --conf ipsec.conf

