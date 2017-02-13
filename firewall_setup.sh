#!/bin/bash

user_side_port="$(ifconfig | grep -B 1 $private | head -1 | awk {'print($1)'})"
wan_side_port="$(ifconfig | grep -B 1 $altra | head -1 | awk {'print($1)'})"
default_gw="$(route -n | grep "UG" | head -1 | awk {'print($2)'})"
broker_ip="$(cat /etc/openbaton/ems/conf.ini | grep broker_ip | awk -F "=" {'print($2)'})"

echo "user_side_port: $user_side_port"
echo "wan_side_port: $wan_side_port"

echo "executing command: sudo route add -host $broker_ip gw $default_gw"
sudo route add -host $broker_ip gw $default_gw
echo "executing command: sudo route del default"
sudo route del default
echo "executing command: sudo dhclient -v $wan_side_port"
sudo dhclient -v $wan_side_port

echo "executing command: sudo sysctl -w net.ipv4.ip_forward=1"
sudo sysctl -w net.ipv4.ip_forward=1
echo "executing command: iptables -t nat -A POSTROUTING -o $wan_side_port -j MASQUERADE"
iptables -t nat -A POSTROUTING -o $wan_side_port -j MASQUERADE

echo "Displaying routing table:"
route