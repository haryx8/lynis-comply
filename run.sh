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

ANS(){
	ACT=$1
	echo 
	while true; do
	    read -p "Do you want to apply? " yn
	    case $yn in
	        [Yy]* ) $ACT;break;;
	        [Nn]* ) break;;
	        * ) echo "Please answer Yes or No.";;
	    esac
	done
}

QST-HRDN-7230 () {
	echo 
	echo Harden the system by installing at least one malware scanner, to perform periodic file system scans [HRDN-7230]
	echo Solution : Install a tool like rkhunter, chkrootkit, OSSEC
	echo https://cisofy.com/lynis/controls/HRDN-7230/
}
ACT-HRDN-7230 () {
	yum install rkhunter
}

QST-FINT-4350 () {
	echo 
	echo Install a file integrity tool to monitor changes to critical and sensitive files [FINT-4350]
	echo https://cisofy.com/lynis/controls/FINT-4350/
}
ACT-FINT-4350 () {
	yum install aide
	aide --init
	mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
	ls -lt /var/lib/aide
	aide --check
	aide --update
}

QST-BANN-7126 () {
	echo 
	echo Add a legal banner to /etc/issue, to warn unauthorized users [BANN-7126]
	echo https://cisofy.com/lynis/controls/BANN-7126/
}
ACT-BANN-7126 () {
	cat banner.txt > /etc/issue
	cat /etc/issue
}

QST-BANN-7130 () {
	echo 
	echo Add legal banner to /etc/issue.net, to warn unauthorized users [BANN-7130]
	echo https://cisofy.com/lynis/controls/BANN-7130/
}
ACT-BANN-7130 () {
	cat banner.txt > /etc/issue.net
	cat /etc/issue.net
}

QST-PKGS-7384 () {
	echo 
	echo package 'yum-utils' for better consistency checking of the package database [PKGS-7384]
	echo https://cisofy.com/lynis/controls/PKGS-7384/
}
ACT-PKGS-7384 () {
	yum install yum-utils
}

QST-PHP-2372 () {
	echo 
	echo Turn off PHP information exposure [PHP-2372]
    echo Details  : expose_php = Off
    echo https://cisofy.com/lynis/controls/PHP-2372/
}
ACT-PHP-2372 () {
	while IFS= read -r line; do
		echo set expose_php = Off on $line
    	sed -i -e 's/expose_php = On/expose_php = Off/' $line
    	sed -i -e 's/expose_php=On/expose_php=Off/' $line
    	echo $line && cat $line | grep expose_php
	done < php_ini.txt
}

QST-PHP-2376 () {
	echo 
	echo Change the allow_url_fopen line to: allow_url_fopen = Off, to disable downloads via PHP [PHP-2376]
	echo https://cisofy.com/lynis/controls/PHP-2376/
}
ACT-PHP-2376 () {
	while IFS= read -r line; do
		echo set allow_url_fopen = Off on $line
    	sed -i -e 's/allow_url_fopen = On/allow_url_fopen = Off/' $line
    	sed -i -e 's/allow_url_fopen=On/allow_url_fopen=Off/' $line
    	echo $line && cat $line | grep allow_url_fopen
	done < php_ini.txt
}

QST-MAIL-8820 () {
	echo 
	echo Disable the 'VRFY' command [MAIL-8820:disable_vrfy_command]
	echo Details  : disable_vrfy_command=no
	echo Solution : run postconf -e disable_vrfy_command=yes to change the value
	echo https://cisofy.com/lynis/controls/MAIL-8820/
}
ACT-MAIL-8820 () {
	postconf -e disable_vrfy_command=yes
	postfix reload
	postconf | grep -i ^disable_vrfy_command
}

QST-MAIL-8818 () {
	echo 
	echo "You are advised to hide the mail_name (option: smtpd_banner) from your postfix configuration. Use postconf -e or change your main.cf file (/etc/postfix/main.cf) [MAIL-8818]"
	echo https://cisofy.com/lynis/controls/MAIL-8818/
}
ACT-MAIL-8818 () {
	postconf -e smtpd_banner=$myhostname-ESMTP
	postfix reload
	postconf | grep -i ^smtpd_banner
}

QST-KRNL-5820 () {
	echo 
	echo If not required, consider explicit disabling of core dump in /etc/security/limits.conf file [KRNL-5820]
	echo https://cisofy.com/lynis/controls/KRNL-5820/
}
ACT-KRNL-5820 () {
	echo 'fs.suid_dumpable = 0' >> /etc/sysctl.conf
	sysctl -p
	echo 'ulimit -S -c 0 > /dev/null 2>&1' >> /etc/profile
	echo "* hard core 0" >> /etc/security/limits.conf
}

QST-SSH-7408 () {
	echo 
	echo Consider hardening SSH configuration [SSH-7408]
	echo "Details  : TCPKeepAlive (set YES to NO)"
	echo "Details  : AllowAgentForwarding (set YES to NO)"
	echo "Details  : MaxSessions (set 10 to 2)"
	echo "Details  : MaxAuthTries (set 6 to 3)"
	echo "Details  : LogLevel (set INFO to VERBOSE)"
	echo "Details  : ClientAliveCountMax (set 3 to 2)"
	echo "Details  : AllowTcpForwarding (set YES to NO)"
	#echo "Details  : Compression (set YES to NO)"
	#echo "Details  : X11Forwarding (set YES to NO)"
	echo https://cisofy.com/lynis/controls/SSH-7408/
}
ACT-SSH-7408 () {
	cat /etc/ssh/sshd_config |grep TCPKeepAlive
	sed -i -e 's/#TCPKeepAlive yes/TCPKeepAlive no/' /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep TCPKeepAlive

	cat /etc/ssh/sshd_config |grep AllowAgentForwarding
	sed -i -e 's/#AllowAgentForwarding yes/AllowAgentForwarding no/' /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep AllowAgentForwarding

	cat /etc/ssh/sshd_config |grep MaxSessions
	sed -i -e 's/#MaxSessions 10/MaxSessions 2/' /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep MaxSessions

	cat /etc/ssh/sshd_config |grep MaxAuthTries
	sed -i -e 's/#MaxAuthTries 6/MaxAuthTries 3/' /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep MaxAuthTries

	cat /etc/ssh/sshd_config |grep LogLevel
	sed -i -e 's/#LogLevel INFO/LogLevel VERBOSE/' /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep LogLevel

	cat /etc/ssh/sshd_config |grep ClientAliveCountMax
	sed -i -e 's/#ClientAliveCountMax 3/ClientAliveCountMax 2/' /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep ClientAliveCountMax

	cat /etc/ssh/sshd_config |grep AllowTcpForwarding
	sed -i -e 's/#AllowTcpForwarding yes/AllowTcpForwarding no/' /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep AllowTcpForwarding

	cat /etc/ssh/sshd_config |grep X11Forwarding
	sed -i -e 's/X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
	cat /etc/ssh/sshd_config |grep X11Forwarding
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

QST-PHP-2372
ANS ACT-PHP-2372

QST-PHP-2376
ANS ACT-PHP-2376

QST-MAIL-8820
ANS ACT-MAIL-8820

QST-MAIL-8818
ANS ACT-MAIL-8818

QST-KRNL-5820
ANS ACT-KRNL-5820

QST-SSH-7408
ANS ACT-SSH-7408

echo 
echo "Task Complete!"