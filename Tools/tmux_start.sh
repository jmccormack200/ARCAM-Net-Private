#!/bin/bash

# Requires sshpasss
# sudo apt-get install sshpass

SESSION=$USER

# Function to connect to all sessins
# format should be:
#		connect user pass ip

# To turn on network type:
#	sudo bash tmux_start.sh

# To Stop type:
# 	tmux ls
# Then:
#	sudo tmux kill-session -t <name from above command>


#TODO:
#
#	config file

connect(){

	tmux new-window 
	tmux rename-window $3
	tmux split-window -v

	tmux select-pane -t 0
	
	ip=$1@$3.local

	ssh="sshpass -p $2 ssh -X $ip"
	tmux send-keys "$ssh" C-m
	
	tmux send-keys "cd SDR/SDR/Flowgraphs" C-m
	tmux send-keys "echo $2 | sudo -S python broadcastwithFreqNoMac.py --tx-gain 45 --rx-gain 45" C-m

	tmux select-pane -t 1
	tmux send-keys "$ssh" C-m
	tmux send-keys "sleep 10s" C-m
	tmux send-keys "echo $2 | sudo -S sh ~/SDR/SDR/WebInterface/static/shell/raiseBatSignal.sh" C-m
	
	tmux send-keys "echo $2 | sudo -S ifconfig bat0 192.168.200.$3" C-m

	tmux send-keys "sleep 10s" C-m
	
	#tmux send-keys "sudo python ../ZMQ/batarang.py bat0" C-m

	tmux send-keys "echo $2 | sudo -S batctl o -w" C-m

}

user='vtclab'
pass='vtclab'


# IP List
#Create file of local ubuntu ips
avahi-browse -tl _workstation._tcp | grep IPv4 | awk '{print $4}' > local_ips.txt



# Start Session
tmux -2 new-session -d -s $SESSION

#read file line by line
while read ip; do
	#connect each machine
	echo "Connecting $ip..."
	connect $user $pass $ip
done < local_ips.txt


# Connect to setup session
tmux -2 attach-session -t $SESSION



