#!/bin/bash
#connect.sh $1=user $2=pass $3=hostname

workDir1="/ARCAM-Net-Public/Tools/"
workDir2="/ARCAM-Net-Private/Tools/"

echo "Connnecting to $1@$3..."
sshpass -p $2 ssh -tt -X $1@$3
sleep 5

echo "Connnected to $(hostname)"
sleep 5


if(cd $workDir1); then
else
	cd $workDir2
fi


echo $2 | sudo -S ifconfig bat0 down
echo $2 | sudo -S ifconfig tun0 down

echo $2 | sudo -S python ../Flowgraphs/broadcastwithFreqNoMac.py --tx-gain 45 --rx-gain 45 &

sleep 10
echo "Waiting for tun0 setup..."
sleep 10 
echo "Waiting..."
sleep 10./

echo $2 | sudo -S bash raiseBatSignal.sh

last=$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk -F'.' '{print $4}' | awk '{print $1}')

batip="192.168.200.$last"

echo "Ip resolved to $batip"

echo $2 | sudo -S ifconfig bat0 $batip

sleep 10


echo $2 | sudo -S batctl o -w
