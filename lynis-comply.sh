#!/bin/bash
clear

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
white=`tput setaf 7`
reset=`tput sgr0`

echo "Prepared by"

ANS(){
	ACT=$1
	echo 
	while true; do
	    read -p "Do you want to apply?" yn
	    case $yn in
	        [Yy]* ) $ACT;break;;
	        [Nn]* ) break;;
	        * ) echo "Please answer Yes or No.";;
	    esac
	done
}

QST-HRDN-7230 () {
	echo Harden the system by installing at least one malware scanner, to perform periodic file system scans [HRDN-7230]
	echo Solution : Install a tool like rkhunter, chkrootkit, OSSEC
	echo https://cisofy.com/lynis/controls/HRDN-7230/
}
ACT-HRDN-7230 () {
	yum install rkhunter
}

QST-FINT-4350 () {
	echo Install a file integrity tool to monitor changes to critical and sensitive files [FINT-4350] 
    echo https://cisofy.com/lynis/controls/FINT-4350/
}
ACT-FINT-4350 () {
	yum install aide
}


QST-HRDN-7230
ANS ACT-HRDN-7230

QST-FINT-4350
ANS ACT-FINT-4350

echo "Task Complete!"