#!/bin/bash
date=$(date +%T)
IFS=:
ary=($date)
hour=${ary[0]}
case "$hour" in
10) tc qdisc del dev wlan0 root
tc qdisc add dev wlan0 root handle 1:0 htb
tc class add dev wlan0 parent 1:0 classid 1:1 htb rate 100mbps
tc class add dev wlan0 parent 1:1 classid 1:2 htb rate 1mbps ceil 100mbps
tc class add dev wlan0 parent 1:1 classid 1:3 htb rate 100kbps ceil 100mbps
tc class add dev wlan0 parent 1:1 classid 1:4 htb rate 10kbps ceil 10kbps
tc class add dev wlan0 parent 1:1 classid 1:5 htb rate 100mbps ceil 100mbps
tc qdisc add dev wlan0 parent 1:2 handle 20: sfq perturb 10
tc qdisc add dev wlan0 parent 1:3 handle 30: sfq perturb 10
tc qdisc add dev wlan0 parent 1:4 handle 40: sfq perturb 10
tc qdisc add dev wlan0 parent 1:5 handle 50: sfq perturb 10
tc filter add dev wlan0 protocol ip parent 1:1 u32 match ip dst 10.7.2.24 flowid 1:2
tc filter add dev wlan0 protocol ip parent 1:1 u32 match ip dst 10.6.5.343 flowid 1:3
tc filter add dev wlan0 protocol ip parent 1:1 u32 match ip dst 10.7.2.22 flowid 1:4
;;
21) tc qdisc del dev wlan0 root
tc qdisc add dev wlan0 root handle 1:0 htb
tc class add dev wlan0 parent 1:0 classid 1:1 htb rate 100mbps
tc class add dev wlan0 parent 1:1 classid 1:2 htb rate 1Mbps ceil 100mbps
tc class add dev wlan0 parent 1:1 classid 1:3 htb rate 100kbps ceil 100mbps
tc class add dev wlan0 parent 1:1 classid 1:4 htb rate 10kbps ceil 10kbps
tc class add dev wlan0 parent 1:1 classid 1:5 htb rate 100mbps ceil 100mbps
tc qdisc add dev wlan0 parent 1:2 handle 20: sfq perturb 10
tc qdisc add dev wlan0 parent 1:3 handle 30: sfq perturb 10
tc qdisc add dev wlan0 parent 1:4 handle 40: sfq perturb 10
tc qdisc add dev wlan0 parent 1:5 handle 50: sfq perturb 10
tc filter add dev wlan0 protocol ip parent 1:1 u32 match ip dst 10.7.2.24 flowid 1:2
tc filter add dev wlan0 protocol ip parent 1:1 u32 match ip dst 10.6.5.343 flowid 1:3
tc filter add dev wlan0 protocol ip parent 1:1 u32 match ip dst 10.7.2.22 flowid 1:4
;;
*) tc qdisc del dev wlan0 root
;;
esac
