#!/bin/bash
date=$(date +%T)
IFS=:
ary=($date)
hour=${ary[0]}
case "$hour" in
1) tc qdisc del dev eth1 root
tc qdisc add dev eth1 root handle 1:0 htb default 2
tc class add dev eth1 parent 1:0 classid 1:1 htb rate 100mbps
tc class add dev eth1 parent 1:1 classid 1:2 htb rate 100mbps
tc class add dev eth1 parent 1:1 classid 1:3 htb rate 1mbps ceil 100mbps
tc class add dev eth1 parent 1:1 classid 1:4 htb rate 100kbps ceil 100mbps
tc class add dev eth1 parent 1:1 classid 1:5 htb rate 10kbps ceil 10kbps
tc qdisc add dev eth1 parent 1:2 handle 20: sfq perturb 10
tc qdisc add dev eth1 parent 1:3 handle 30: sfq perturb 10
tc qdisc add dev eth1 parent 1:4 handle 40: sfq perturb 10
tc qdisc add dev eth1 parent 1:5 handle 50: sfq perturb 10
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip src 10.7.2.24 flowid 1:3
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip src 10.6.5.343 flowid 1:4
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip dst 10.7.2.22 flowid 1:5
iptables -I INPUT -i eth1 -s 10.7.2.24 -j DROP
iptables -I INPUT -i eth1 -s 10.7.2.2 -j DROP
;;
10) tc qdisc del dev eth1 root
tc qdisc add dev eth1 root handle 1:0 htb default 2
tc class add dev eth1 parent 1:0 classid 1:1 htb rate 100mbps
tc class add dev eth1 parent 1:1 classid 1:2 htb rate 100mbps
tc class add dev eth1 parent 1:1 classid 1:3 htb rate 1Mbps ceil 100mbps
tc class add dev eth1 parent 1:1 classid 1:4 htb rate 100kbps ceil 100mbps
tc class add dev eth1 parent 1:1 classid 1:5 htb rate 10kbps ceil 10kbps
tc qdisc add dev eth1 parent 1:2 handle 20: sfq perturb 10
tc qdisc add dev eth1 parent 1:3 handle 30: sfq perturb 10
tc qdisc add dev eth1 parent 1:4 handle 40: sfq perturb 10
tc qdisc add dev eth1 parent 1:5 handle 50: sfq perturb 10
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip src 10.7.2.24 flowid 1:3
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip src 10.6.5.343 flowid 1:4
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip dst 10.7.2.22 flowid 1:5
iptables -I INPUT -i eth1 -s 10.7.2.24 -j DROP
iptables -I INPUT -i eth1 -s 10.7.2.2 -j DROP
;;
11) tc qdisc del dev eth1 root
tc qdisc add dev eth1 root handle 1:0 htb default 2
tc class add dev eth1 parent 1:0 classid 1:1 htb rate 100mbps
tc class add dev eth1 parent 1:1 classid 1:2 htb rate 100mbps
tc class add dev eth1 parent 1:1 classid 1:3 htb rate 1Mbps ceil 100mbps
tc class add dev eth1 parent 1:1 classid 1:4 htb rate 100kbps ceil 100mbps
tc class add dev eth1 parent 1:1 classid 1:5 htb rate 10kbps ceil 10kbps
tc qdisc add dev eth1 parent 1:2 handle 20: sfq perturb 10
tc qdisc add dev eth1 parent 1:3 handle 30: sfq perturb 10
tc qdisc add dev eth1 parent 1:4 handle 40: sfq perturb 10
tc qdisc add dev eth1 parent 1:5 handle 50: sfq perturb 10
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip src 10.7.2.24 flowid 1:3
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip src 10.6.5.343 flowid 1:4
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip dst 10.7.2.22 flowid 1:5
iptables -I INPUT -i eth1 -s 10.7.2.24 -j DROP
iptables -I INPUT -i eth1 -s 10.7.2.2 -j DROP
;;
*) tc qdisc del dev eth1 root
;;
esac
