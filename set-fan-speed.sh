#!/bin/bash

# $OPTION is hardcoded for now
OPTION=100

#Checks to make sure .env file exists, then imports the variables. 
ENV_FILE="$(dirname "$0")/.env"
if [ ! -f "$ENV_FILE" ]; then
	echo "Missing .env file at $ENV_FILE" >&2
	exit 1
fi
set -a
source "$ENV_FILE"
set +a

# Main
if [ "$OPTION" -eq 1 ]; then
	echo "Option $OPTION"
	# Disables third party PCIe response
	ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" raw 0x30 0xce 0x00 0x16 0x5 0x00 0x00 0x00 0x05 0x00 0x01 0x00 0x00
elif [ "$OPTION" -eq 2 ]; then
	echo "Option $OPTION"
	# Tells iDRAC to stop managing the fans
	ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" raw 0x30 0x30 0x01 0x00
elif [ "$OPTION" -eq 3 ]; then
	echo "Option $OPTION"
	# Sets all fans to 20%
	ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" raw 0x30 0x30 0x02 0xff 0x14
elif [ "$OPTION" -eq 4 ]; then
	echo "Option $OPTION"
	# Reverts control of fan speed to automatic
	ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" raw 0x30 0x30 0x01 0x01
else
	echo "Option not recognized"
fi
