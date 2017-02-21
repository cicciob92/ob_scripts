#!/bin/bash

user_side_port="$(ifconfig | grep -B 1 $private4 | head -1 | awk {'print($1)'})"
wan_side_port="$(ifconfig | grep -B 1 $private3 | head -1 | awk {'print($1)'})"

echo "user_side_port: $user_side_port"
echo "wan_side_port: $wan_side_port"

echo "executing command: sudo sysctl -w net.ipv4.ip_forward=1"
sudo sysctl -w net.ipv4.ip_forward=1
echo "executing command: iptables -t nat -A POSTROUTING -o $wan_side_port -j MASQUERADE"
iptables -t nat -A POSTROUTING -o $wan_side_port -j MASQUERADE

echo "Displaying routing table:"
route
