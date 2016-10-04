#!/bin/bash

# Requires sshpasss
# sudo apt-get install sshpass

# Function to connect to all sessins
# format should be:
#		connect user pass ip

# To turn on network type:
#	sudo bash gnuscreens_start.sh
user='vtclab'
pass='vtclab'
host=$(hostname)

# IP List
#Create file of local ubuntu ips
avahi-browse -tl _workstation._tcp | grep IPv4 | awk '{print $4}' > local_ips.txt

#!/bin/bash

 


#read file line by line
while read ip; do
	#connect each machine
	echo "Connecting $ip..."
	connectusr="bash connect.sh $user $pass $ip.local"
	xterm -title $ip -e $connectusr &
done < local_ips.txt

echo "Connecting $host..."
connecthost="bash connect.sh $user $pass $host.local"
xterm -title $host -e $connecthost &

