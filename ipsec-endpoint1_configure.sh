#!/bin/bash

user_side_port="$(ifconfig | grep -B 1 $private2 | head -1 | awk {'print($1)'})"
wan_side_port="$(ifconfig | grep -B 1 $altra | head -1 | awk {'print($1)'})"
default_gw="$(route -n | grep "UG" | head -1 | awk {'print($2)'})"
broker_ip="$(cat /etc/openbaton/ems/conf.ini | grep broker_ip | awk -F "=" {'print($2)'})"
user_net="$(echo $private2 | awk -F "." '{OFS = ".";}{print $1,$2,$3,"0/24"}')"
external_net="$(echo $altra | awk -F "." '{OFS = ".";}{print $1,$2,$3,"0/24"}')"
peer_user_net="$(echo $ipsec_endpoint1_private | awk -F "." '{OFS = ".";}{print $1,$2,$3,"0/24"}')"

#enable ipv4 forwarding
sysctl -w net.ipv4.ip_forward=1

#set SAD and SPD
echo "setting ipsec keys"
echo "add $altra $ipsec_endpoint1_altra esp 0x1001 -m tunnel -u 100 -E aes-cbc 0xaa112233445566778811223344556677;" > setKey.conf
echo "add $ipsec_endpoint1_altra $altra esp 0x2001 -m tunnel -u 101 -E aes-cbc 0xbb112233445566778811223344556677;" >> setKey.conf
echo "spdadd $user_net $external_net any -P out ipsec esp/tunnel/$altra-$ipsec_endpoint1_altra/unique:100;" >> setKey.conf
echo "spdadd $external_net $user_net any -P in ipsec esp/tunnel/$ipsec_endpoint1_altra-$altra/unique:101;" >> setKey.conf
setkey -f setKey.conf

#set the right default gateway
echo "Setting the right route entries"
route add -host $broker_ip gw $default_gw
route del default
dhclient -v $wan_side_port
new_default_gw="$(route -n | grep "UG" | head -1 | awk {'print($2)'})"
route del default

#create table for policy-based routing
table="pbtable"
echo -e "1\t$table" >> /etc/iproute2/rt_tables

#outgoing traffic
ip route add default via $new_default_gw dev $wan_side_port table $table

#set entry from the VPN network to the local host
ip route add $peer_user_net via $private2 dev $user_side_port table $table

#redirect traffic generated by IPsec
iptables -t mangle -A OUTPUT -p 50 -m esp --espspi 0x1001 -j MARK --set-mark 0x$(echo "obase=16; $1" | bc)ecec #mark outgoing traffic (which enters into the tunnel)
ip rule add fwmark 0x$(echo "obase=16; $1" | bc)ecec table $table
ip rule add from $peer_user_net to $private2 table $table


