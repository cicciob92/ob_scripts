#!/bin/bash


echo "executing command: sudo route add default gw $ipsecpeer1_private2"
route add default gw $ipsecpeer1_private2

echo "Displaying routing table:"
route -n
