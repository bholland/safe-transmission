# safe-transmission
This wraps the transmission client in a VPN kill switch

# Dependencies
This depends on network manager and the transmission-daemon.

This will use a transmission user called transmission (NOT debian-transmission) to execute
transmission. At boot, safe-transmission.sh script will start up a
vpn with the given name (NordVPN) via /usr/bin/nmcli con up NordVPN. It will then add a mangle
rule where all packets coming into the system from the transmission user will get managed with
a mark 0x1. The iptables rules with require all packets with 0x1 come from the tun0 interface
or they get dropped. It will also only send packets over the tun0 interface. If your VPN
connection drops, the user transmission will not be able to send or recieve packets. This ensures
safe operations of a transmission server behind a VPN.

The install script attempts to be as friendly as possible but this will change configurations.
Most importantly, this will change the ip tables v4, the transmission-daemon.service file, and
the routes table.

The iptables_clear.sh command will clear out all current ip tables rules. I find this helpful for debugging
purposes. The install script will run this as part of the install of this package.

The install script works on the RPi 4 running both bullseye and buster. It probably works with Jesse too.

This does not touch transmission configuration files. It will force the safe-transmission service to run
before the transmission-daemon service to set up the networking rules.

Please report any bugs to benedict.m.holland@gmail.com or open a github ticket. I am currently trying to
make this into a deb package but for now, run the install.sh script to install the uninstall.sh script to
