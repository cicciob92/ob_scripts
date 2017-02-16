#!/bin/bash


echo "executing command: sudo route add default gw $firewall_private"
route add default gw $firewall_private

echo "Displaying routing table:"
route -n
