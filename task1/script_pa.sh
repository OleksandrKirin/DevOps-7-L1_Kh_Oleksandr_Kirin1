#!/bin/bash
#This function lists TCP ports wich was opened on host 
function portscan
{
echo "The following ports are open:"
ss -ant | sort -k 4
}

# This function shows existing IP addresses and names of hosts in asked network 
function netscan
{
#Checking what NMAP in installed
test -e /usr/bin/nmap
if [[ "$?" == "0" ]]
then
echo "NMAP is installed, let's scan network..."
else
echo "NMAP isn't installed, let's install NMAP..."
sudo apt install nmap -y
fi
#Perform scanning network with NMAP
addr=$1
echo "These hosts has been found on this network:"
nmap -sP $addr | awk 'NR % 2 == 0 {print "Hostname: " $5 "   " "IP Address: " $6}' | sed 's/(//g; s/)//g'
}

#This condition was written to show a list of possible keys and their description
if [[ "$#" == "0" ]]
then
echo "List of applicable arguments: "
echo -e "\033[33m '--all' - to show the IP addresses and symbolic names of all hosts in the current subnet \033[0m"
echo -e  "\033[33m '--target' - to show a list of opened TPC ports in the system. For example: './script_a.sh --target 192.168.1.*' \033[0m"
exit 0
fi

# Block for checking conditions of inputed parameters.
if [ "$1" == "--all" ]
then
portscan
elif [ "$1" == "--target" ]
then
netscan $2
fi