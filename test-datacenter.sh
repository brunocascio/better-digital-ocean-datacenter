#!/bin/sh

bold=$(tput bold)
normal=$(tput sgr0)

better_ping=99999
better_datacenter=''
better_datacenter_name=''
max_ping=$1

while read -r line;
do
	ping_avg=`ping -c $max_ping $line | tail -n1 | cut -d'=' -f2 | cut -d'/' -f2`
	if [ -z "$ping_avg" ]
	then
		echo "Ping ${bold}${line}${normal}: not available"
		continue
	fi
	echo "Ping ${bold}${line}${normal}: $ping_avg ms"
	if [ $(echo "$ping_avg < $better_ping" | bc) -eq 1 ];
	then
		better_ping=$ping_avg
		better_datacenter=$line
		better_datacenter_name=`echo $line | cut -d'.' -f1 | cut -d'-' -f2`
	fi
done < "$2"

echo ""
echo "${bold}---------------------- Better Datacenter is -----------------------------------${normal}"
echo "${bold}Domain${normal}: $better_datacenter"
echo "${bold}Ping AVG${normal}: $better_ping ms"
echo "${bold}Name${normal}: $better_datacenter_name"
echo "${bold}-------------------------------------------------------------------------------${normal}"
echo ""
