#!/bin/bash

echo "executing command: sudo route add default gw $nat_private4"
sudo route add default gw $nat_private4

echo "Displaying routing table:"
route -n
