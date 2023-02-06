#! /bin/bash

file=/usr/bin/safe_transmission.log
echo "starting safe_transmission" > $file

if ! /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"; then
    echo "tun0 connection not found" >> $file
    # /usr/bin/nmcli con up NordVPN
    #/usr/bin/nordvpn connect
    #sleep 5

    #uncomment this to start
    /usr/bin/nmcli con up NordVPN
fi

if /sbin/ifconfig tun0 | grep -q "00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00"; then
    echo "tun0 found." >> $file
    VPNIF="tun0"
    VPNUSER="transmission"
    GATEWAYIP=$(ip address show dev tun0 | awk '/inet.*brd/ {print $2}' | awk -F'/' '{print $1}')
    echo "VPNIF: $VPNIF" >> $file
    echo "VPNUSER: $VPNUSER" >> $file
    echo "GATEWAY: $GATEWAYIP" >> $file

    echo "rule list" >> $file
    /sbin/ip rule list >> $file
    
    if [[ `/sbin/ip rule list | /bin/grep -c 0x1` == 0 ]]; then
	# this assumes that there is a table called $VPNUSER in the rt_tables file located at:
	# sudo emacs /etc/iproute2/rt_tables

	#uncomment this to add the rule
	/sbin/ip rule add from all fwmark 0x1 lookup $VPNUSER
    fi
    #uncomment this too
    /sbin/ip route replace default via $GATEWAYIP table $VPNUSER
    /sbin/ip route append default via 127.0.0.1 dev lo table $VPNUSER
    /sbin/ip route flush cache
    echo "new ip rules" >> $file
    /sbin/ip rule list >> $file
else
    echo "tun0 not found" >> /usr/bin/safe_transmission.log
fi
