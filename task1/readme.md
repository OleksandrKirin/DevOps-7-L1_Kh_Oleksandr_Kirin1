#tstagro/DevOps_7_Poltava_2022
#Task 1.1

*## Part A.*
# ./script_pa

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

Screenshot - t71pa_port.jpg

*##Part B.*
# ./script_pb

#!/bin/bash
#List of arguments which can be used in the script.
if [[ "$# == "0" ]]
then
echo -e "\033[31m Warning! Script was run without any arguments! \033[0m"
echo "How to use: ./script_b.sh [--argument] [file_to_check] [TOP(N)]"
echo "For example: ./script_b.sh --most_requested_page apache_logs.txt 20"
echo "For this script applicable next arguments:"
echo -e "\033[37m --ip_mr \033[33m	- to display from which IP were made the most requests \033[0m"
echo -e "\033[37m --mrp \033[33m	- to display the most requested page \033[0m"
echo -e "\033[37m --hmr_fip \033[33m	- to display how many requests were there from each IP \033[0m"
echo -e "\033[37m --404	\033[33m		- to display what non-existent pages were clients refferred to \033[0m"
echo -e "\033[37m --time_mr	\033[33m	- to display what time did site get the most requests \033[0m"
echo -e "\033[37m --sbot	\033[33m	- to display what search bots have accessed the site \033[0m"
echo -e "\033[0m"
exit 0
fi

# Description of the accordance of arguments and functions.
if [ "$1" == "--ip_mr" ]
then
mpir $2 $3
elif [ "$1" == "--mrp" ]
then
mrp $2 $3
elif [ "$1" == "--hmr_fip" ]
then
ripc $2 $3
elif [ "$1" == "--404" ]
then 
err404 $2 $3
elif [ "$1" == "--time_mr" ]
then
reqcount $2 $3
elif [ "$1" == "--sbot" ]
then
searchbot $2 $3
fi

#This is to show which IP sent the most requests
function mpir
{
if [[ -z "$1" ]]
then
echo -e "\033[31m You must specify the log-file first! \033[0m"
exit 0
elif [[ -z "$2" ]]
then
echo -e "\033[31m You must specify the amount of lines! \033[0m"
exit 0
fi
logname=$1
echo -e "\033[35m The most $2 popular addresses which made requests \033[0m"
cat $logname | grep -E -o "([0-9]{1,3}[\.]{3}[0-9]{1,3})" | sort | uniq -c | sort -gr | head -n $2
}

#This is to show what is the most requested page
function mrp
{
if [[ -z "$1" ]]
then
echo -e "\033[31m You must specify the log-file first! \033[0m"
exit 0
elif [[ -z "$2" ]]
then
echo -e "033[31m You must specify the number of lines! \033[0m"
exit 0
fi
logname=$1
echo -e "\033[35m The most $2 requested pages: \033[0m"
cat $logname | awk '{print $7}' | sort | uniq -c | sort -gr | head -n $2 | sed 's/\///g' 
}

#This is to show how many requests were made from each IP
function ripc
{
if [[ -z "$1" ]]
then
echo -e "\033[31 You must specify the log-file first! \033[0m"
exit 0
elif [[ -z "$2" ]]
then
echo -e "\033[31m You must specify number of lines! \033[0m"
exit 0
fi
logname=$1
echo -e "\033[32m How many requests were made from each IP? \033[0m"
cat $logname |grep -e -o "([0-9]{1,3}[\.]{3}[0-9]{1,3})" | sort | uniq -c | sort -gr | awk '{print "There is " "\033[35m" $1 "\033[0m" "requests from IP: " $2}' | head -n $2
}

#This is necessary in order to show which non-existent pages customers have linked to. 
function err404
{
if [[ -z "$1" ]]
then
echo -e "\033[31 You must specify the log-file first! \033[0m"
exit 0
elif [[ -z "$2" ]]
then
echo -e "\033[31m You must specify number of lines! \033[0m"
exit 0
fi
echo -e "\033[32m Which non-existent pages customers have linked to? \033[0m"
echo -e "\033[35m List of non-existent pages: \033[0m'
logname=$1
grep "404 " $logname | awk '{print "There is \" $7 "\ has been visited"}' | uniq | sed 's/\///g' | head -n $2  
}

#To show what time did site get the most requests
function hitime
{
if [[ -z "S1" ]]
then
echo -e "\033[31 ERROR! you must specify the log-file first! \033[0m"
exit 0
elif [[ -z "$2" ]]
then
echo -e "\033[31m ERROR! You must specify number of lines! \033[0m"
exit 0
fi
echo -e "033[33m What time did site get the most requests? \033[0m"
logname=$1
cat $logname | awk '{print "\033[36m The time did site get the most requests is:  \033[0m  " $4 "]"}' | sort | uniq -c | sort -gr | head -n $2
}

#This is to show what search bots have accessed the site (UA+IP)
function searchbot
{
if [[ -z "$1" ]]
then
echo -e "\033[31 You must specify the log-file first! \033[0m"
exit 0
elif [[ -z "$2" ]]
then
echo -e "\033[31m You must specify number of lines! \033[0m"
exit 0
fi
echo -e "\033[33m What search bots have accessed the site? (UA+IP) \033[0m"
logname=$1
grep "bot" $logname |awk -F\" '{print $6}' | sort | uniq -c | head -n $2
}



*##Part C.*
# ./script_pc

#!/bin/bash

#List of arguments which can be used in the script.
if [[ "$#" == "0" ]]
then
echo -e "\033[33m For this script actually next arguments:"
echo -e "For example: ./script_c.sh [path_to_source_folder] [path_to_destination_folder] \033[0m"
exit 0
elif ! [[ -d $1 ]]
then
echo -e "\033[31m Warning! Source directory not existed! \033[0m"
exit 0
elif [[ -z $2 ]]
then
echo -e "\033[31m You must specify destination directory! \033[0m"
exit 0
elif ! [[ -d $2 ]]
then
echo -e "\033[31m Target folder not found, I will create it $2 ! \033[0m"
mkdir "$2"
echo -e "\033[35m Target folder $2 was created! \033[0m"
fi

#Set parameters
srcdir=$1
dstdir=$2
log=$dstdir/backup.log
tmpdir=$dstdir/tmp

if ! [[ -d $tmpdir ]]; 
then
mkdir $tmpdir
fi
touch $dstdir/backup.log ; $tmpdir/ls.tmp ; $tmpdir/snapshot.tmp

ls $srcdir > $tpmdir/ls.tmp;

# Archving and logging
dt=$(date +%d.%m.%Y_%H:%M:%S);
for var1 in $(diff -y --suppress-common-lines $tmpdir/ls.tmp $tmpdir/snapshot.tmp |awk '{print $1}' |sed 's/>//g; /^[[:space:]]*$/d')
do
echo "$dt CREATED $var1" >> $log
tar -rvf $dstdir/backup.tar $srcdir/$var1 > /dev/null
echo "$dt BACKUPED $var1" >> $log
done
echo "Backuped!"
for var2 in $(diff -y --suppress-common-lines $tmpdir/ls.tmp $tmpdir/snapshot.tmp |awk '{print $2 $3}' |sed 's/<//g; /^[[:space:]]*$/d; s/|//g')
do
echo "$dt DELETED $var2" >> $log
done
rm -rf $tmpdir/ls.tmp;
ls $srcdir > $tmpdir/snapshot.tmp


