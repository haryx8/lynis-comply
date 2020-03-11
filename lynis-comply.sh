#!/bin/bash
clear

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
c4=`tput setaf 4`
c5=`tput setaf 5`
c6=`tput setaf 6`
white=`tput setaf 7`
reset=`tput sgr0`

echo "${red}Prepared ${white}by ${yellow}hary[at]sgo[dot]co[dot]id${reset}"
echo 

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

QST-BANN-7126 () {
	echo Add a legal banner to /etc/issue, to warn unauthorized users [BANN-7126] 
    echo https://cisofy.com/lynis/controls/BANN-7126/
}
ACT-BANN-7126 () {
	cat banner.txt > /etc/issue
}

QST-BANN-7130 () {
	echo Add legal banner to /etc/issue.net, to warn unauthorized users [BANN-7130] 
    echo https://cisofy.com/lynis/controls/BANN-7130/
}
ACT-BANN-7130 () {
	cat banner.txt > /etc/issue.net
}

QST-PKGS-7384 () {
	echo package 'yum-utils' for better consistency checking of the package database [PKGS-7384] 
    echo https://cisofy.com/lynis/controls/PKGS-7384/
}
ACT-PKGS-7384 () {
	yum install yum-utils
}

QST-HRDN-7230
ANS ACT-HRDN-7230

QST-FINT-4350
ANS ACT-FINT-4350

QST-BANN-7126
ANS ACT-BANN-7126

QST-BANN-7130
ANS ACT-BANN-7130

QST-PKGS-7384
ANS ACT-PKGS-7384

echo 
echo "Task Complete!"