#!/bin/bash
#luke was here
# ssh into all linux devices
user="vtclab"
pass="vtclab"
host=$(hostname)

# IP List
#Create file of local ubuntu ips
#avahi-browse -tl _workstation._tcp | grep IPv4 | awk '{print $4}' > /home/vtclab/Share/tools/local_ips.txt


#read file line by line
while read ip; do
	#connect each machine
	echo "ssh into $ip..."
	sshuser="sshpass -p $pass ssh -oStrictHostKeyChecking=no -tt -X $user@$ip.local "
	commands="echo $pass | sudo -S $1"

	if [ ! -z "$2" ]
	  then
	    commands="cd $2 && echo $pass | sudo -S $1"
	    echo $commands
	fi

	
	$sshuser $commands &
	

done < /home/vtclab/Share/tools/local_ips.txt


