#!/bin/bash
#
# Script para controle de banda em gateway

#Rede interna
interface[0]=eth1
#Internet
interface[1]=eth0

#Arquivo de configuração
CfgFile="bandctl.cfg"
#Iniciando marcador
mark=2


start()
{

for iface in ${interface[@]}
do
tc qdisc del dev $iface root
tc qdisc add dev $iface root handle 1 cbq bandwidth 10Mbit avpkt 1000 cell 8
tc class change dev $iface root cbq weight 1Mbit allot 1514
done

for i in $(grep -v "^#" $CfgFile)
do
ip=$(echo $i | cut -d "-" -f 1)
down=$(echo $i | cut -d "-" -f 2)
up=$(echo $i | cut -d "-" -f 3)

#Download
tc class add dev ${interface[0]} parent 1: classid 1:$mark cbq bandwidth 10Mbit rate "$down"Kbit weight $(expr $down / 10)Kbit prio 5 allot 1514 cell 8 maxburst 20 avpkt 1000 bounded
tc qdisc add dev ${interface[0]} parent 1:$mark handle $mark sfq perturb 10
tc filter add dev ${interface[0]} parent 1:0 protocol ip prio 200 handle $mark fw classid 1:$mark

iptables -t mangle -A POSTROUTING -d $ip -j MARK --set-mark $mark


#Upload
tc class add dev ${interface[1]} parent 1: classid 1:$mark cbq bandwidth 10Mbit rate "up"Kbit weight $(expr $rateout / 10)Kbit prio 5 allot 1514 cell 8 maxburst 20 avpkt 1000 bounded
tc qdisc add dev ${interface[1]} parent 1:$mark handle $mark  sfq perturb 10
tc filter add dev ${interface[1]} parent 1:0 protocol ip prio 200 handle $mark fw classid 1:$mark

iptables -t mangle -A FORWARD -s $ip -j MARK --set-mark $mark



#Incrementando marcador
let mark++

done 
}


stop()
{
for iface in ${interface[@]}
do
	tc qdisc del dev $iface root
	iptables -t mangle -F
done
}


case $1 in
	start)
	start
	;;
	stop)
	stop
	;;
	*)
	echo "Use $0 { start | stop }"
	;;
esac
