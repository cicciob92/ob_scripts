#!/bin/bash

default_gw="$(route -n | grep "UG" | head -1 | awk {'print($2)'})"
broker_ip="$(cat /etc/openbaton/ems/conf.ini | grep broker_ip | awk -F "=" {'print($2)'})"

echo "executing command: sudo route add -host $broker_ip gw $default_gw"
sudo route add -host $broker_ip gw $default_gw
echo "executing command: sudo route del default"
sudo route del default
echo "executing command: sudo route add default gw $firewall_private"
sudo route add default gw $firewall_private

echo "Displaying routing table:"
route -n
