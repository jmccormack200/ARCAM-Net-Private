#!/bin/bash
#arcam_up.sh $1=user $2=pass $3=hostname

#Configuration variables
workDir1="~/ARCAM-Net-Public/Tools/"
workDir2="~/ARCAM-Net-Private/Tools/"
meshiface="bat0"
physiface="tun0"
tun0Script="python ../Flowgraphs/broadcastwithFreqNoMac.py --tx-gain 45 --rx-gain 45"
bat0Script="bash raiseBatSignal.sh"
IPconfigScript="avahi-autoipd"

#configuration translation
script="Script"
physScript="$physiface$script"
meshScript="$meshiface$script"
monitorScript="batctl o -w"

echo "Running configuration..."
echo "		meshiface=$meshiface"
echo "		physiface=$physiface"
echo "		physScript=${!physScript}"
echo "		meshScript=${!meshScript}"
echo "		IPconfigScript=$IPconfigScript"
echo "		monitorScript=$monitorScript"

sleep 5

echo "Connnected to $(hostname)"

sleep 5

#change to working directory
cd $workDir1 || cd $workDir2


#shutdown leftover interfaces
echo $2 | sudo -S ifconfig $meshiface down
echo $2 | sudo -S ifconfig $physiface down

#Layer 1 setup
echo $2 | sudo -S ${!physScript} &

#Wait
sleep 5
echo "Waiting for $physiface setup..."
sleep 5
echo "Waiting..."
sleep 5

#Layer 2 Setup
n=0
until [ $n -ge 5 ]
do
  echo "Connecting $meshiface..."
  echo $2 | sudo -S ${!meshScript} && break  
  n=$[$n+1]
  sleep 20
done

#Configure IP

echo $2 | sudo -S $IPconfigScript $meshiface &
#echo $2 | sudo -S $IPconfigScript $physiface &

#ethX=$(ifconfig | grep eth | awk '{print $1}')

#last=$(ifconfig $ethX  | grep 'inet addr:' | cut -d: -f2 | awk -F'.' '{print $4}' | awk '{print $1}')

#batip="192.168.200.$last"

#echo "Ip resolved to $batip"

#echo $2 | sudo -S ifconfig bat0 $batip
#echo $2 | sudo -S ifconfig tun0 $batip

sleep 15

$monitorScript
