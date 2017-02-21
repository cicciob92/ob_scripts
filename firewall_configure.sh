#!/bin/bash


echo "executing command: sudo route add default gw $firewall_private4"
route add default gw $firewall_private4

echo "Displaying routing table:"
route -n
