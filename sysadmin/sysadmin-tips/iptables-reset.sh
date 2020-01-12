#!/bin/sh
#
# flush-iptables script.
# author: https://askubuntu.com/questions/1116919/destination-host-unreachable-sharing-wifi-from-ubuntu-to-win10/1117043
#

# First delete all rules in the tables
iptables -F
iptables -t nat -F
iptables -t mangle -F

# Add default rules to the filter, nat & mangle tables:
iptables -P OUTPUT ACCEPT
iptables -P PREROUTING ACCEPT
iptables -P POSTROUTING ACCEPT

iptables -t nat -P INPUT ACCEPT
iptables -t nat -P OUTPUT ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

iptables -P INPUT ACCEPT
iptables -P INPUT ACCEPT
iptables -P INPUT ACCEPT

# Remove all non-default chains in filter, nat & mangle tables. Usually what UFW adds
iptables -X
iptables -t nat -X
iptables -t mangle -X

# Finally restart network manager
systemctl restart NetworkManager && echo systemctl status NetworkManager
echo "__________________________________________DONE_________________________"
