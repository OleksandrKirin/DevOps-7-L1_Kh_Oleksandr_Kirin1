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
dt=$(date '+%d.%m.%Y_%H:%M:%S);
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