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

connect(){

	tmux split-window -v

	tmux select-pane -t $4

	ssh="sshpass -p $2 ssh -X $1@$3"
	tmux send-keys "$ssh" C-m
	
	tmux send-keys "echo $pass | sudo -S batctl o -w" C-m
}

user='vtclab'
pass='vtclab'



# Start Session
tmux -2 new-session -d -s $SESSION

#read file line by line
n=0
while read ip; do

	tmux split-window -v
	tmux select-pane -t next

	tmux select-layout even-vertical
	
	connect $user $pass "$ip.local" n

	n=$[$n+1]

done < local_ips.txt


# Connect to setup session
tmux -2 attach-session -t $SESSION



