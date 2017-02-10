#!/bin/bash

user_side_port="$(ifconfig | grep -B 1 $server_private | head -1 | awk {'print($1)'})"
wan_side_port="$(ifconfig | grep -B 1 $server_altra | head -1 | awk {'print($1)'})"

echo "user_side_port: $user_side_port"
echo "wan_side_port: $wan_side_port"

echo "route - output command:"
route

iptables -t nat -A POSTROUTING -o $wan_side_port -j MASQUERADE

