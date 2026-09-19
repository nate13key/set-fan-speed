#!/bin/bash


# Checks to make sure .env exists
ENV_FILE="$(dirname "$0")/.env"
if [ ! -f "$ENV_FILE" ]; then
	echo "Missing .env file at $ENV_FILE" >&2
	exit 1
fi

# Imports variables from .env
set -a
source "$ENV_FILE"
set +a

# Get $OPTION
usage() {
        echo "Usage: $0 [-h | -p | -m | -s | -a]"
        echo "  -h  Show this help message"
        echo "  -p  Disable third-party PCIe response"
        echo "  -m  Enable manual fan management"
        echo "  -s  Set fans to slow (20%)"
        echo "  -a  Revert to automatic fan management"
        exit "${1:-1}"
}

while getopts "hpmsa" opt; do
        if [ -n "$OPTION" ]; then
                echo "Error: only one flag may be specified at a time" >&2
                usage
        fi
        case "$opt" in
                h) usage 0 ;;
                p) OPTION=1 ;;
                m) OPTION=2 ;;
                s) OPTION=3 ;;
                a) OPTION=4 ;;
                *) usage ;;
        esac
done

if [ -z "$OPTION" ]; then
        usage
fi

if [ "$OPTION" -eq 1 ]; then
	echo "Option $OPTION"
	echo "Disabling third party PCIe response"
	ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" raw 0x30 0xce 0x00 0x16 0x5 0x00 0x00 0x00 0x05 0x00 0x01 0x00 0x00
elif [ "$OPTION" -eq 2 ]; then
	echo "Option $OPTION"
	echo "Enabling manual fan management"
	ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" raw 0x30 0x30 0x01 0x00
elif [ "$OPTION" -eq 3 ]; then
	echo "Option $OPTION"
	echo "Setting all fans to 20%"
	ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" raw 0x30 0x30 0x02 0xff 0x14
elif [ "$OPTION" -eq 4 ]; then
	echo "Option $OPTION"
	echo "Reverting control of fan speed to automatic"
	ipmitool -I lanplus -H "$IP" -U "$USERNAME" -P "$PASSWORD" raw 0x30 0x30 0x01 0x01
else
	echo "Option not recognized"
fi
