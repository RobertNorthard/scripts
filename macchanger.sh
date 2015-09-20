#!/bin/bash
#
# Description: Change mac address of specified network interface.
#
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root."
	exit 1
fi

usage() { echo "Usage: $0 [-i interface] [ -m new mac address]" 1>&2; exit 1; }

while getopts ":i:m:" o; do
    case "${o}" in
        i)
			i=${OPTARG}
            ;;
        m)
            m=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${i}" ] || [ -z "${m}" ]; then
    usage
fi

previous_mac=`ifconfig ${i} | grep 'ether' | awk '{print $2}'`
echo "Previous MAC: ${previous_mac}"

ifconfig ${i} ether 00:11:22:33:44:55 

new_mac=$(ifconfig ${i} | grep 'ether' | awk '{print $2}')
echo "New mac: ${new_mac}"

if [ $oldmac = $newmac ]; then
	echo "Erorr: MAC not changed."
	exit 1
fi
