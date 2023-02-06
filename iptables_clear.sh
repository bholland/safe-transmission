#!/bin/bash
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t raw -F
iptables -t raw -X

iptables -F
iptables -X


iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6
