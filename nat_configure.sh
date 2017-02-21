#!/bin/bash

echo "executing command: sudo route add default gw $nat_private"
sudo route add default gw $nat_private

echo "Displaying routing table:"
route -n
