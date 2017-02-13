#!/bin/bash

sudo route del default
sudo route add default gw $firewall_private
echo "Displaying routing table:"
route -n
