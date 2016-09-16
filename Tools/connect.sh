#!/bin/bash
#connect.sh $1=user $2=pass $3=hostname

workDir="/ARCAM-Net-Public/Tools/"

ip='$1@$3.local'
host=$(hostname)

if[$3 -ne $host];then
	echo $2 | sudo -S sshpass -p $2 ssh -X 
fi

echo $2 | sudo -S ifconfig bat0 down
echo $2 | sudo -S ifconfig tun0 down

cd $workDir

echo $2 | sudo -S python ../Flowgraphs/broadcastwithFreqNoMac.py --tx-gain 45 --rx-gain 45 &

sleep 10
echo "Waiting for tun0 setup..."
sleep 10 
echo "Waiting..."
sleep 10

echo $2 | sudo -S bash raiseBatSignal.sh

last=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk -F'.' '{print $4}' | awk '{print $1}')

batip="192.168.200.$last"

echo "Ip resolved to $batip"

echo $2 | sudo -S ifconfig bat0 $batip

sleep 10


echo $2 | sudo -S batctl o -w
