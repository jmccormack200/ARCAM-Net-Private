#!/bin/sh
# sudo bash raiseBatSignal $1=interface

sudo modprobe batman-adv
sudo ip link add name bat0 type batadv
sudo batctl if add $1
sudo ip link set mtu 1532 dev $1 master bat0
#sudo ip link set down tun0
sudo ip link set up $1
#sudo ip link set down bat0
sudo ip link set up bat0