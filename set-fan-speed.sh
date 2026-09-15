#!/bin/bash

# WARNING
#
# I hardcoded $OPTION and the IP, username, and password. I'll update later

OPTION=100

if [ $OPTION -eq 1 ]; then
	echo "Option $OPTION"
	# Disables third party PCIe response
	ipmitool -I lanplus -H 192.168.0.120 -U root -P calvin raw 0x30 0xce 0x00 0x16 0x5 0x00 0x00 0x00 0x05 0x00 0x01 0x00 0x00
elif [ $OPTION -eq 2 ]; then
	echo "Option $OPTION"
	# Tells iDRAC to stop managing the fans
	ipmitool -I lanplus -H 192.168.0.120 -U root -P calvin raw 0x30 0x30 0x01 0x00
elif [ $OPTION -eq 3 ]; then
	echo "Option $OPTION"
	# Sets all fans to 20%
	ipmitool -I lanplus -H 192.168.0.120 -U root -P calvin raw 0x30 0x30 0x02 0xff 0x14
elif [ $OPTION -eq 4 ]; then
	echo "Option $OPTION"
	# Reverts control of fan speed to automatic
	ipmitool -I lanplus -H 192.168.0.120 -U root -P calvin raw 0x30 0x30 0x01 0x01
else
	echo "Option not recognized"
fi
