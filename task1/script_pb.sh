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
