#!/bin/bash


echo "executing command: sudo route add default gw $ipsecpeer1_private3"
route add default gw $ipsecpeer1_private3

echo "Displaying routing table:"
route -n
