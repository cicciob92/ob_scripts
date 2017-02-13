#!/bin/bash

#sudo route del default
#sudo route add default gw $firewall_private

echo "executing command: route add -host 130.192.225.254 gw $firewall_private"
route add -host 130.192.225.254 gw $firewall_private

#echo "Displaying routing table:"
#route -n
