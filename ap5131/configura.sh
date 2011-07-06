#!/bin/bash

export http_proxy=""

if [ -z $1 ]
then
	echo Informe o quarto byte do IP. Ex.: Se o IP for 192.168.0.10, use: $0 10
	exit 1

fi
ip_default="10.1.1.1"
senha="motorola"

ip=192.168.0.$1
mask=255.255.255.0
gw=192.168.0.1
dns1=192.168.0.20
dns2=192.168.0.21
dominio="example.com"

controlador1=200.200.200.201
controlador2=200.200.200.202

cmdb_server="cmdb"
snmp_community="public"


mac_wan=$(snmpget -O vq -v 2c -c public $ip_default iso.3.6.1.2.1.2.2.1.6.3 | tr "[a-f]" "[A-F]" 2> /dev/null || echo ERR)
mac_lan=$(snmpget -O vq -v 2c -c public $ip_default iso.3.6.1.2.1.2.2.1.6.2  | tr "[a-f]" "[A-F]" 2> /dev/null || echo ERR)

mac_radio1=$(snmpget -O vq -v 2c -c public $ip_default iso.3.6.1.2.1.2.2.1.6.4 | tr "[a-f]" "[A-F]"  2> /dev/null || echo ERR)
mac_radio2=$(snmpget -O vq -v 2c -c public $ip_default iso.3.6.1.2.1.2.2.1.6.7 | tr "[a-f]" "[A-F]"  2> /dev/null || echo ERR)

array_mac_wan[1]=$(echo $mac_wan | cut -d ":" -f 1)
array_mac_wan[2]=$(echo $mac_wan | cut -d ":" -f 2)
array_mac_wan[3]=$(echo $mac_wan | cut -d ":" -f 3)
array_mac_wan[4]=$(echo $mac_wan | cut -d ":" -f 4)
array_mac_wan[5]=$(echo $mac_wan | cut -d ":" -f 5)
array_mac_wan[6]=$(echo $mac_wan | cut -d ":" -f 6)

echo ${array_mac_wan[1]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_wan[1]=0${array_mac_wan[1]}
echo ${array_mac_wan[2]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_wan[2]=0${array_mac_wan[2]}
echo ${array_mac_wan[3]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_wan[3]=0${array_mac_wan[3]}
echo ${array_mac_wan[4]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_wan[4]=0${array_mac_wan[4]}
echo ${array_mac_wan[5]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_wan[5]=0${array_mac_wan[5]}
echo ${array_mac_wan[6]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_wan[6]=0${array_mac_wan[6]}

mac_wan=$(echo ${array_mac_wan[@]} | tr " " "-")

array_mac_lan[1]=$(echo $mac_lan | cut -d ":" -f 1)
array_mac_lan[2]=$(echo $mac_lan | cut -d ":" -f 2)
array_mac_lan[3]=$(echo $mac_lan | cut -d ":" -f 3)
array_mac_lan[4]=$(echo $mac_lan | cut -d ":" -f 4)
array_mac_lan[5]=$(echo $mac_lan | cut -d ":" -f 5)
array_mac_lan[6]=$(echo $mac_lan | cut -d ":" -f 6)

echo ${array_mac_lan[1]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_lan[1]=0${array_mac_lan[1]}
echo ${array_mac_lan[2]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_lan[2]=0${array_mac_lan[2]}
echo ${array_mac_lan[3]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_lan[3]=0${array_mac_lan[3]}
echo ${array_mac_lan[4]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_lan[4]=0${array_mac_lan[4]}
echo ${array_mac_lan[5]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_lan[5]=0${array_mac_lan[5]}
echo ${array_mac_lan[6]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_lan[6]=0${array_mac_lan[6]}

mac_lan=$(echo ${array_mac_lan[@]} | tr " " "-")

array_mac_radio1[1]=$(echo $mac_radio1 | cut -d ":" -f 1)
array_mac_radio1[2]=$(echo $mac_radio1 | cut -d ":" -f 2)
array_mac_radio1[3]=$(echo $mac_radio1 | cut -d ":" -f 3)
array_mac_radio1[4]=$(echo $mac_radio1 | cut -d ":" -f 4)
array_mac_radio1[5]=$(echo $mac_radio1 | cut -d ":" -f 5)
array_mac_radio1[6]=$(echo $mac_radio1 | cut -d ":" -f 6)

echo ${array_mac_radio1[1]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio1[1]=0${array_mac_radio1[1]}
echo ${array_mac_radio1[2]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio1[2]=0${array_mac_radio1[2]}
echo ${array_mac_radio1[3]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio1[3]=0${array_mac_radio1[3]}
echo ${array_mac_radio1[4]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio1[4]=0${array_mac_radio1[4]}
echo ${array_mac_radio1[5]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio1[5]=0${array_mac_radio1[5]}
echo ${array_mac_radio1[6]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio1[6]=0${array_mac_radio1[6]}

mac_radio1=$(echo ${array_mac_radio1[@]} | tr " " "-")


array_mac_radio2[1]=$(echo $mac_radio2 | cut -d ":" -f 1)
array_mac_radio2[2]=$(echo $mac_radio2 | cut -d ":" -f 2)
array_mac_radio2[3]=$(echo $mac_radio2 | cut -d ":" -f 3)
array_mac_radio2[4]=$(echo $mac_radio2 | cut -d ":" -f 4)
array_mac_radio2[5]=$(echo $mac_radio2 | cut -d ":" -f 5)
array_mac_radio2[6]=$(echo $mac_radio2 | cut -d ":" -f 6)

echo ${array_mac_radio2[1]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio2[1]=0${array_mac_radio2[1]}
echo ${array_mac_radio2[2]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio2[2]=0${array_mac_radio2[2]}
echo ${array_mac_radio2[3]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio2[3]=0${array_mac_radio2[3]}
echo ${array_mac_radio2[4]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio2[4]=0${array_mac_radio2[4]}
echo ${array_mac_radio2[5]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio2[5]=0${array_mac_radio2[5]}
echo ${array_mac_radio2[6]} | egrep "^[0-9A-Z]{1}$" > /dev/null && array_mac_radio2[6]=0${array_mac_radio2[6]}

mac_radio2=$(echo ${array_mac_radio2[@]} | tr " " "-")
#if [ $mac_wan == "ERR" ] || [ $mac_lan == "ERR" ]
#then
#	echo "ABORTADO - Erro acessando ip default $ip_default"
#	exit 2
#fi

echo " "
echo "IP default: $ip_default"
echo "IP novo: $ip"
echo "MAC WAN: "$mac_wan
echo "MAC LAN: "$mac_lan
echo "MAC RADIO1: "$mac_radio1
echo "MAC RADIO2: "$mac_radio2
echo " "
echo "INFORME OS DADOS. NÃO USE ESPAÇO!!!"
read -p "Local: " loc
read -p "Predio: " predio
read -p "Andar: " andar
read -p "Numero: " numero
echo " "
read -p "Descrição: " descricao
read -p "Patrimonio: " patrimonio

arquivo="files/$ip.cfg"
> $arquivo


echo "//" >> $arquivo
echo "// ADP-51xx Configuration Command Script " >> $arquivo
echo "// System Firmware Version: 2.3.1.0-001R" >> $arquivo
echo "//" >> $arquivo
echo "dual-radio-hardware" >> $arquivo
echo "//" >> $arquivo
echo "cfg-version-00" >> $arquivo
echo "//" >> $arquivo
echo "// Admin Password" >> $arquivo
echo "/" >> $arquivo
echo "enc-admin-passwd a55654c62e2f7072" >> $arquivo
echo "/" >> $arquivo
echo "// System Configuration" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "set name AP$loc$predio$andar$numero" >> $arquivo
echo "set loc $descricao" >> $arquivo
echo "set email admin@$dominio" >> $arquivo
echo "set cc br" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "aap-setup" >> $arquivo
echo "// Adaptive AP menu" >> $arquivo
echo "set auto-discovery enable" >> $arquivo
echo "set interface lan1" >> $arquivo
echo "set name \0" >> $arquivo
echo "set port 24576" >> $arquivo
echo "delete all" >> $arquivo
echo "set ipadr 1 $controlador1" >> $arquivo
echo "set ipadr 2 $controlador2" >> $arquivo
echo "set enc-passphrase bf0819993a702c39" >> $arquivo
echo "set ac-keepalive 5" >> $arquivo
echo "set tunnel-to-switch disable" >> $arquivo
echo "/" >> $arquivo
echo "// System-Access menu" >> $arquivo
echo "system" >> $arquivo
echo "access" >> $arquivo
echo "set applet lan 1 enable" >> $arquivo
echo "set applet slan 1 enable" >> $arquivo
echo "set cli lan 1 enable" >> $arquivo
echo "set ssh lan 1 enable" >> $arquivo
echo "set snmp lan 1 enable" >> $arquivo
echo "set applet lan 2 enable" >> $arquivo
echo "set applet slan 2 enable" >> $arquivo
echo "set cli lan 2 enable" >> $arquivo
echo "set ssh lan 2 enable" >> $arquivo
echo "set snmp lan 2 enable" >> $arquivo
echo "set admin-auth radius" >> $arquivo
echo "set applet wan enable" >> $arquivo
echo "set applet swan enable" >> $arquivo
echo "set app-timeout 0" >> $arquivo
echo "set cli wan enable" >> $arquivo
echo "set ssh wan enable" >> $arquivo
echo "set auth-timeout 120" >> $arquivo
echo "set inactive-timeout 120" >> $arquivo
echo "set snmp wan enable" >> $arquivo
echo "set server 192.168.0.4" >> $arquivo
echo "set port 1812" >> $arquivo
echo "set enc-secret bf0819993a702c39" >> $arquivo
echo "set admin-auth local" >> $arquivo
echo "set mode disable" >> $arquivo
echo "set msg \0" >> $arquivo
echo "set trusted-host mode disable" >> $arquivo
echo "/" >> $arquivo
echo "// System-SNMP-Access Configuration" >> $arquivo
echo "system" >> $arquivo
echo "snmp" >> $arquivo
echo "access" >> $arquivo
echo "// SNMP ACL configuration" >> $arquivo
echo "delete acl all" >> $arquivo
echo "// SNMP v1/v2c configuration" >> $arquivo
echo "delete v1v2c all" >> $arquivo
echo "add v1v2c $snmp_community ro 1.3.6.1" >> $arquivo
echo "// SNMP v3 user definitions" >> $arquivo
echo "delete v3 all" >> $arquivo
echo "/" >> $arquivo
echo "// System-SNMP-Traps Configuration" >> $arquivo
echo "system" >> $arquivo
echo "snmp" >> $arquivo
echo "traps" >> $arquivo
echo "// SNMP trap selection" >> $arquivo
echo "set mu-assoc disable" >> $arquivo
echo "set mu-unassoc disable" >> $arquivo
echo "set mu-deny-assoc disable" >> $arquivo
echo "set mu-deny-auth disable" >> $arquivo
echo "set snmp-auth disable" >> $arquivo
echo "set snmp-acl disable" >> $arquivo
echo "set port disable" >> $arquivo
echo "set dos-attack disable" >> $arquivo
echo "set interval 10" >> $arquivo
echo "set cold disable" >> $arquivo
echo "set cfg disable" >> $arquivo
echo "set rogue-ap disable" >> $arquivo
echo "set ap-radar disable" >> $arquivo
echo "set wpa-counter disable" >> $arquivo
echo "set hotspot-mu-status disable" >> $arquivo
echo "set vlan disable" >> $arquivo
echo "set lan-monitor disable" >> $arquivo
echo "set min-pkt 1000" >> $arquivo
echo "set dyndns-update disable" >> $arquivo
echo "// SNMP v1/v2c trap configuration" >> $arquivo
echo "delete v1v2c all" >> $arquivo
echo "// SNMP v3 trap configuration" >> $arquivo
echo "delete v3 all" >> $arquivo
echo "/" >> $arquivo
echo "// System-NTP menu" >> $arquivo
echo "system" >> $arquivo
echo "ntp" >> $arquivo
echo "set mode disable" >> $arquivo
echo "/" >> $arquivo
echo "// System-Logs menu" >> $arquivo
echo "system" >> $arquivo
echo "logs" >> $arquivo
echo "set level L6" >> $arquivo
echo "set mode disable" >> $arquivo
echo "/" >> $arquivo
echo "// System-Config Update menu" >> $arquivo
echo "system" >> $arquivo
echo "config" >> $arquivo
echo "set file cfg.txt" >> $arquivo
echo "set path \0" >> $arquivo
echo "set mode ftp" >> $arquivo
echo "set server 192.168.0.10" >> $arquivo
echo "set user \0" >> $arquivo
echo "set enc-passwd d2" >> $arquivo
echo "/" >> $arquivo
echo "// System-Firmware Update menu" >> $arquivo
echo "system" >> $arquivo
echo "fw-update" >> $arquivo
echo "set fw-auto enable" >> $arquivo
echo "set cfg-auto enable" >> $arquivo
echo "set mode off" >> $arquivo
echo "set file tf.bin" >> $arquivo
echo "set path \0" >> $arquivo
echo "set server 192.168.0.10" >> $arquivo
echo "set user \0" >> $arquivo
echo "set enc-passwd d2" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "userdb" >> $arquivo
echo "user" >> $arquivo
echo "// userdb user configuration" >> $arquivo
echo "clearall " >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "userdb" >> $arquivo
echo "group" >> $arquivo
echo "// userdb group configuration" >> $arquivo
echo "clearall " >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "radius" >> $arquivo
echo "// radius server configuration" >> $arquivo
echo "set database local" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "radius" >> $arquivo
echo "eap" >> $arquivo
echo "// radius EAP configuration" >> $arquivo
echo "set auth all" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "radius" >> $arquivo
echo "eap" >> $arquivo
echo "peap" >> $arquivo
echo "// radius EAP PEAP configuration" >> $arquivo
echo "set auth gtc" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "radius" >> $arquivo
echo "eap" >> $arquivo
echo "ttls" >> $arquivo
echo "// radius EAP TTLS configuration" >> $arquivo
echo "set auth pap" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "radius" >> $arquivo
echo "ldap" >> $arquivo
echo "// radius LDAP configuration" >> $arquivo
echo "set port 389" >> $arquivo
echo "set binddn cn=Manager,o=trion" >> $arquivo
echo "set basedn o=trion" >> $arquivo
echo "set enc-passwd d2" >> $arquivo
echo "set login (uid=%{Stripped-User-Name:-%{User-Name}})" >> $arquivo
echo "set pass_attr userPassword" >> $arquivo
echo "set groupname cn" >> $arquivo
echo "set filter (|(&(objectClass=GroupOfNames)(member=%{Ldap-UserDn}))(&(objectClass=GroupOfUniqueNames)(uniquemember=%{Ldap-UserDn})))" >> $arquivo
echo "set membership radiusGroupName" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "radius" >> $arquivo
echo "proxy" >> $arquivo
echo "// radius proxy server configuration" >> $arquivo
echo "set delay 5" >> $arquivo
echo "set count 3" >> $arquivo
echo "// radius proxy realm configuration" >> $arquivo
echo "clearall " >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "radius" >> $arquivo
echo "client" >> $arquivo
echo "// radius client configuration" >> $arquivo
echo "/" >> $arquivo
echo "// /Network-WAN configuration" >> $arquivo
echo "network" >> $arquivo
echo "wan" >> $arquivo
echo "set wan 1 disable" >> $arquivo
echo "set dhcp disable" >> $arquivo
echo "set pppoe mode disable" >> $arquivo
echo "/" >> $arquivo
echo "// Network-WAN-NAT configuration" >> $arquivo
echo "network" >> $arquivo
echo "wan" >> $arquivo
echo "nat" >> $arquivo
echo "// wan ip 1" >> $arquivo
echo "set type 1 1-to-many" >> $arquivo
echo "set inb mode 1 disable" >> $arquivo
echo "// Inbound NAT configuration" >> $arquivo
echo "// wan ip 1" >> $arquivo
echo "delete 1 all" >> $arquivo
echo "// wan ip 2" >> $arquivo
echo "set type 2 none" >> $arquivo
echo "// Inbound NAT configuration" >> $arquivo
echo "// wan ip 2" >> $arquivo
echo "delete 2 all" >> $arquivo
echo "// wan ip 3" >> $arquivo
echo "set type 3 none" >> $arquivo
echo "// Inbound NAT configuration" >> $arquivo
echo "// wan ip 3" >> $arquivo
echo "delete 3 all" >> $arquivo
echo "// wan ip 4" >> $arquivo
echo "set type 4 none" >> $arquivo
echo "// Inbound NAT configuration" >> $arquivo
echo "// wan ip 4" >> $arquivo
echo "delete 4 all" >> $arquivo
echo "// wan ip 5" >> $arquivo
echo "set type 5 none" >> $arquivo
echo "// Inbound NAT configuration" >> $arquivo
echo "// wan ip 5" >> $arquivo
echo "delete 5 all" >> $arquivo
echo "// wan ip 6" >> $arquivo
echo "set type 6 none" >> $arquivo
echo "// Inbound NAT configuration" >> $arquivo
echo "// wan ip 6" >> $arquivo
echo "delete 6 all" >> $arquivo
echo "// wan ip 7" >> $arquivo
echo "set type 7 none" >> $arquivo
echo "// Inbound NAT configuration" >> $arquivo
echo "// wan ip 7" >> $arquivo
echo "delete 7 all" >> $arquivo
echo "// wan ip 8" >> $arquivo
echo "set type 8 none" >> $arquivo
echo "// Inbound NAT configuration" >> $arquivo
echo "// wan ip 8" >> $arquivo
echo "delete 8 all" >> $arquivo
echo "// Outbound 1-To-Many NAT configuration" >> $arquivo
echo "set outb map lan 1" >> $arquivo
echo "set outb map lan2 1" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "wan" >> $arquivo
echo "vpn" >> $arquivo
echo "delete all" >> $arquivo
echo "// VPN configuration" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "wan" >> $arquivo
echo "vpn" >> $arquivo
echo "delete all" >> $arquivo
echo "/" >> $arquivo
echo "// Network-WAN-Content Filtering configuration" >> $arquivo
echo "network" >> $arquivo
echo "wan" >> $arquivo
echo "content" >> $arquivo
echo "delcmd web proxy " >> $arquivo
echo "delcmd web activex " >> $arquivo
echo "delcmd smtp helo " >> $arquivo
echo "delcmd smtp mail " >> $arquivo
echo "delcmd smtp rcpt " >> $arquivo
echo "delcmd smtp data " >> $arquivo
echo "delcmd smtp quit " >> $arquivo
echo "delcmd smtp send " >> $arquivo
echo "delcmd smtp saml " >> $arquivo
echo "delcmd smtp reset " >> $arquivo
echo "delcmd smtp vrfy " >> $arquivo
echo "delcmd smtp expn " >> $arquivo
echo "delcmd ftp put " >> $arquivo
echo "delcmd ftp get " >> $arquivo
echo "delcmd ftp ls " >> $arquivo
echo "delcmd ftp mkdir " >> $arquivo
echo "delcmd ftp cd " >> $arquivo
echo "delcmd ftp pasv " >> $arquivo
echo "delcmd web file all" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "addcmd web file \0" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-Security configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "security" >> $arquivo
echo "set wpa-countermeasure enable" >> $arquivo
echo "delete all" >> $arquivo
echo "// Security Policy 1 configuration" >> $arquivo
echo "edit 1" >> $arquivo
echo "set auth none" >> $arquivo
echo "set enc none" >> $arquivo
echo "change" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-ACL configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "acl" >> $arquivo
echo "delete all" >> $arquivo
echo "// MU ACL Policy 1 configuration" >> $arquivo
echo "edit 1" >> $arquivo
echo "set mode allow" >> $arquivo
echo "delete all" >> $arquivo
echo "change" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-WMM_QOS configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "qos" >> $arquivo
echo "delete all" >> $arquivo
echo "// WMM-QoS Policy 1 configuration" >> $arquivo
echo "edit 1" >> $arquivo
echo "set vop disable" >> $arquivo
echo "set mcast 1 01005E000000" >> $arquivo
echo "set mcast 2 09000E000000" >> $arquivo
echo "set wmm-qos disable" >> $arquivo
echo "set param-set 11ag-default" >> $arquivo
echo "change" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-WLAN configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "wlan" >> $arquivo
echo "delete all" >> $arquivo
echo "// WLAN 1 configuration" >> $arquivo
echo "create" >> $arquivo
echo "set ess 101" >> $arquivo
echo "set wlan-name WLAN1" >> $arquivo
echo "set max-mu 127" >> $arquivo
echo "set enc-passwd d2" >> $arquivo
echo "set no-mu-mu disable" >> $arquivo
echo "set sbeacon disable" >> $arquivo
echo "set bcast enable" >> $arquivo
echo "set 11a enable" >> $arquivo
echo "set 11bg enable" >> $arquivo
echo "set mesh enable" >> $arquivo
echo "set hotspot disable" >> $arquivo
echo "set security Default" >> $arquivo
echo "set acl Default" >> $arquivo
echo "set qos Default" >> $arquivo
echo "add-wlan" >> $arquivo
echo "/" >> $arquivo
echo "system" >> $arquivo
echo "radius" >> $arquivo
echo "policy" >> $arquivo
echo "// radius access policy configuration" >> $arquivo
echo "access-time" >> $arquivo
echo "// radius access time rule configuration" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-WLAN-Hotspot configuration" >> $arquivo
echo "// Hotspot Redirection configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "wlan" >> $arquivo
echo "hotspot" >> $arquivo
echo "redirection" >> $arquivo
echo "// Wlan 1 - Hotspot Redirection configuration" >> $arquivo
echo "set page-loc 1 default" >> $arquivo
echo "set exturl 1 login \0" >> $arquivo
echo "set exturl 1 welcome \0" >> $arquivo
echo "set exturl 1 fail \0" >> $arquivo
echo "/" >> $arquivo
echo "// Hotspot Radius configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "wlan" >> $arquivo
echo "hotspot" >> $arquivo
echo "radius" >> $arquivo
echo "// Wlan 1 - Hotspot Radius configuration" >> $arquivo
echo "set acct-mode 1 disable" >> $arquivo
echo "set acct-timeout 1 10" >> $arquivo
echo "set acct-retry 1 3" >> $arquivo
echo "set acct-port 1 1813" >> $arquivo
echo "set enc-acct-secret 1 d2" >> $arquivo
echo "set port 1 primary 1812" >> $arquivo
echo "set enc-secret 1 primary d2" >> $arquivo
echo "set port 1 secondary 1812" >> $arquivo
echo "set enc-secret 1 secondary d2" >> $arquivo
echo "set sess-mode 1 disable" >> $arquivo
echo "/" >> $arquivo
echo "// Hotspot Whitelist configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "wlan" >> $arquivo
echo "hotspot" >> $arquivo
echo "white-list" >> $arquivo
echo "clear rule all" >> $arquivo
echo "// Hotspot Whitelist 1 configuration" >> $arquivo
echo "/" >> $arquivo
echo "/" >> $arquivo
echo "// Network-wireless-Rogue_AP configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "rogue-ap" >> $arquivo
echo "set mu-scan disable" >> $arquivo
echo "set interval 15" >> $arquivo
echo "set on-channel disable" >> $arquivo
echo "set motorola-ap disable" >> $arquivo
echo "set applst-ageout 0" >> $arquivo
echo "set roglst-ageout 0" >> $arquivo
echo "set ABG-scan disable" >> $arquivo
echo "set detector-scan disable" >> $arquivo
echo "// Rogue AP Allowed AP list" >> $arquivo
echo "allowed-list" >> $arquivo
echo "delete all" >> $arquivo
echo "/" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-Radio configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "radio" >> $arquivo
echo "set 11a enable" >> $arquivo
echo "set mesh-base 2 disable" >> $arquivo
echo "set mesh-client 2 disable" >> $arquivo
echo "set mesh-max 2 12" >> $arquivo
echo "set mesh-wlan 2 \0" >> $arquivo
echo "set 11bg enable" >> $arquivo
echo "set mesh-base 1 disable" >> $arquivo
echo "set mesh-client 1 disable" >> $arquivo
echo "set mesh-max 1 12" >> $arquivo
echo "set mesh-wlan 1 \0" >> $arquivo
echo "set rf-function 1 wlan" >> $arquivo
echo "set rf-function 2 wlan" >> $arquivo
echo "set dot11-auth open-system-only" >> $arquivo
echo "radio1" >> $arquivo
echo "// 802.11b/g Radio Configuration" >> $arquivo
echo "set rates 1,2,5.5,11 1,2,5.5,6,9,11,12,18,24,36,48,54" >> $arquivo
echo "set beacon 100" >> $arquivo
echo "set dtim 1 10" >> $arquivo
echo "set dtim 2 10" >> $arquivo
echo "set dtim 3 10" >> $arquivo
echo "set dtim 4 10" >> $arquivo
echo "set preamble disable" >> $arquivo
echo "set placement outdoor" >> $arquivo
echo "set ch-mode auto" >> $arquivo
echo "set channel 1" >> $arquivo
echo "set antenna full" >> $arquivo
echo "set power 20" >> $arquivo
echo "set rts 2347" >> $arquivo
echo "set qbss-beacon 10" >> $arquivo
echo "set qbss-mode enable" >> $arquivo
echo "set qos param-set 11g-default" >> $arquivo
echo "// Radio Advanced Configuration" >> $arquivo
echo "advanced" >> $arquivo
echo "set wlan WLAN1 1" >> $arquivo
echo "set bss 1 WLAN1" >> $arquivo
echo ".." >> $arquivo
echo "// Radio Advanced Mesh Configuration" >> $arquivo
echo "mesh" >> $arquivo
echo "set auto-select enable" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "radio" >> $arquivo
echo "radio2" >> $arquivo
echo "// 802.11a Radio Configuration" >> $arquivo
echo "set rates 6,12,24 6,9,12,18,24,36,48,54" >> $arquivo
echo "set beacon 100" >> $arquivo
echo "set dtim 1 10" >> $arquivo
echo "set dtim 2 10" >> $arquivo
echo "set dtim 3 10" >> $arquivo
echo "set dtim 4 10" >> $arquivo
echo "set placement outdoor" >> $arquivo
echo "set ch-mode uniform" >> $arquivo
echo "set channel 100" >> $arquivo
echo "set antenna full" >> $arquivo
echo "set power 20" >> $arquivo
echo "set rts 2347" >> $arquivo
echo "set qbss-beacon 10" >> $arquivo
echo "set qbss-mode enable" >> $arquivo
echo "set qos param-set 11a-default" >> $arquivo
echo "// Radio Advanced Configuration" >> $arquivo
echo "advanced" >> $arquivo
echo "set wlan WLAN1 1" >> $arquivo
echo "set bss 1 WLAN1" >> $arquivo
echo ".." >> $arquivo
echo "// Radio Advanced Mesh Configuration" >> $arquivo
echo "mesh" >> $arquivo
echo "set auto-select enable" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-bandwidth configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "bandwidth" >> $arquivo
echo "set mode 1 fifo" >> $arquivo
echo "set mode 2 fifo" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-mu-locationing configuration" >> $arquivo
echo "network" >> $arquivo
echo "wireless" >> $arquivo
echo "mu-locationing" >> $arquivo
echo "set mode disable" >> $arquivo
echo "set size 200" >> $arquivo
echo "/" >> $arquivo
echo "// /Network-LAN configuration" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "lan" >> $arquivo
echo "// Ethernet Port configuration" >> $arquivo
echo "set auto-negotiation disable" >> $arquivo
echo "set speed 100M" >> $arquivo
echo "set duplex full" >> $arquivo
echo "set auto-negotiation enable" >> $arquivo
echo "" >> $arquivo
echo "set lan 1 enable" >> $arquivo
echo "set trunking 1 disable" >> $arquivo
echo "set name 1 LAN1" >> $arquivo
echo "set ip-mode 1 static" >> $arquivo
echo "set lan 2 disable" >> $arquivo
echo "set trunking 2 disable" >> $arquivo
echo "set name 2 LAN2" >> $arquivo
echo "set ip-mode 2 server" >> $arquivo
echo "set timeout 0" >> $arquivo
echo "set username admin" >> $arquivo
echo "set enc-passwd bf0819993a702c39" >> $arquivo
echo "// Port To Subnet Map configuration" >> $arquivo
echo "set ethernet-port-lan 1" >> $arquivo
echo "set ipadr 1 $ip" >> $arquivo
echo "set mask 1 $mask" >> $arquivo
echo "set dgw 1 $gw" >> $arquivo
echo "set domain 1 $dominio" >> $arquivo
echo "set dns 1 1 $dns1" >> $arquivo
echo "set dns 1 2 $dns2" >> $arquivo
echo "set wins 1 0.0.0.0" >> $arquivo
echo "set ipadr 2 192.168.1.1" >> $arquivo
echo "set mask 2 255.255.255.0" >> $arquivo
echo "set dgw 2 192.168.1.1" >> $arquivo
echo "set domain 2 \0" >> $arquivo
echo "set dns 2 1 192.168.1.1" >> $arquivo
echo "set dns 2 2 192.168.1.1" >> $arquivo
echo "set wins 2 192.168.1.254" >> $arquivo
echo "// Network-LAN-DHCP configuration" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "lan" >> $arquivo
echo "dhcp" >> $arquivo
echo "set lease 2 86400" >> $arquivo
echo "set range 2 192.168.1.100 192.168.1.254" >> $arquivo
echo "delete 2 all" >> $arquivo
echo "// LAN Bridge configuration" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "lan" >> $arquivo
echo "bridge" >> $arquivo
echo "set priority 1 65500" >> $arquivo
echo "set hello 1 2" >> $arquivo
echo "set msgage 1 20" >> $arquivo
echo "set fwddelay 1 15" >> $arquivo
echo "set ageout 1 300" >> $arquivo
echo "set priority 2 65500" >> $arquivo
echo "set hello 2 2" >> $arquivo
echo "set msgage 2 20" >> $arquivo
echo "set fwddelay 2 15" >> $arquivo
echo "set ageout 2 300" >> $arquivo
echo "/" >> $arquivo
echo "// Network-LAN-VLAN configuration" >> $arquivo
echo "network" >> $arquivo
echo "lan" >> $arquivo
echo "wlan-mapping" >> $arquivo
echo "// WLAN To LAN Map configuration" >> $arquivo
echo "lan-map WLAN1 LAN1" >> $arquivo
echo "set mgmt-tag 1 1" >> $arquivo
echo "set native-tag 1 1" >> $arquivo
echo "set mgmt-tag 2 1" >> $arquivo
echo "set native-tag 2 1" >> $arquivo
echo "delete all" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Wireless-Filter configuration" >> $arquivo
echo "network" >> $arquivo
echo "lan" >> $arquivo
echo "type-filter" >> $arquivo
echo "// Ethernet Type Filter Policy for LAN 1" >> $arquivo
echo "" >> $arquivo
echo "set mode 1 allow" >> $arquivo
echo "delete 1 all " >> $arquivo
echo "// Ethernet Type Filter Policy for LAN 2" >> $arquivo
echo "" >> $arquivo
echo "set mode 2 allow" >> $arquivo
echo "delete 2 all " >> $arquivo
echo "/" >> $arquivo
echo "// Network-Firewall configuration" >> $arquivo
echo "network" >> $arquivo
echo "firewall" >> $arquivo
echo "set mode enable" >> $arquivo
echo "set nat-timeout 10" >> $arquivo
echo "set syn enable" >> $arquivo
echo "set src  enable" >> $arquivo
echo "set win enable" >> $arquivo
echo "set ftp enable" >> $arquivo
echo "set ip enable" >> $arquivo
echo "set seq enable" >> $arquivo
echo "set mime  enable" >> $arquivo
echo "set len 8192" >> $arquivo
echo "set hdr 16" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "firewall" >> $arquivo
echo "access" >> $arquivo
echo "// LAN to WAN Access Rule" >> $arquivo
echo "set rule lan wan allow" >> $arquivo
echo "set rule lan lan2 allow" >> $arquivo
echo "set rule lan2 wan allow" >> $arquivo
echo "set rule lan2 lan allow" >> $arquivo
echo "delete lan all " >> $arquivo
echo "delete lan2 all " >> $arquivo
echo "/" >> $arquivo
echo "// Advanced LAN Access configuration" >> $arquivo
echo "network" >> $arquivo
echo "firewall" >> $arquivo
echo "advanced" >> $arquivo
echo "// enable override to go to inbound sub-menu" >> $arquivo
echo "set override enable" >> $arquivo
echo "// Inbound policy configuration" >> $arquivo
echo "inbound" >> $arquivo
echo "delete all" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "firewall" >> $arquivo
echo "advanced" >> $arquivo
echo "// enable override to go to outbound sub-menu" >> $arquivo
echo "set override enable" >> $arquivo
echo "// Outbound policy configuration" >> $arquivo
echo "outbound" >> $arquivo
echo "delete all" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "firewall" >> $arquivo
echo "advanced" >> $arquivo
echo "// Restore back user-defined override mode" >> $arquivo
echo "set override disable" >> $arquivo
echo "/" >> $arquivo
echo "// Network-Router configuration" >> $arquivo
echo "network" >> $arquivo
echo "router" >> $arquivo
echo "set type off" >> $arquivo
echo "set dir both" >> $arquivo
echo "set auth none" >> $arquivo
echo "set enc-passwd d2" >> $arquivo
echo "set id 1 1" >> $arquivo
echo "set enc-key 1 e2565fc57c2a766fb0d55160d6f92952" >> $arquivo
echo "set id 2 2" >> $arquivo
echo "set enc-key 2 e2565fc57c2a766fb0d55160d6f92952" >> $arquivo
echo "delete all" >> $arquivo
echo "set dgw-iface lan1" >> $arquivo
echo "/" >> $arquivo
echo "network" >> $arquivo
echo "wan" >> $arquivo
echo "dyndns" >> $arquivo
echo "// DynDNS menu" >> $arquivo
echo "set mode disable" >> $arquivo
echo "set username \0" >> $arquivo
echo "set password \0" >> $arquivo
echo "set hostname \0" >> $arquivo
echo "/" >> $arquivo
echo "save" >> $arquivo



echo ""
echo "Arquivo de Configuração gerado."

if [ $loc == "CX" ]
then
	Id_Unidade=""
elif [  $loc == "BG" ]
then
	Id_Unidade=""
elif [  $loc == "VA" ]
then
	Id_Unidade=""
elif [  $loc == "C8" ]
then
	Id_Unidade=""
elif [  $loc == "CA" ]
then
	Id_Unidade=""
elif [  $loc == "FR" ]
then
	Id_Unidade=""
elif [  $loc == "GU" ]
then
	Id_Unidade=""
elif [  $loc == "NP" ]
then
	Id_Unidade=""
elif [  $loc == "VE" ]
then
	Id_Unidade=""
elif [  $loc == "SC" ]
then
	Id_Unidade=""
elif [  $loc == "AP" ]
then
	Id_Unidade=""
elif [  $loc == "MN" ]
then
	Id_Unidade=""
elif [  $loc == "SM" ]
then
	Id_Unidade=""
elif [  $loc == "TA" ]
then
	Id_Unidade="1"
else
	Id_Unidade=""
fi


echo ""
echo "Abrindo firefox para cadastramento no cmdb..."
firefox "https://$cmdb_server.$dominio/swmanager/cadastraap.php?Id_Unidade=$Id_Unidade&Nome=AP$loc$predio$andar$numero&IP=$ip&MAC_LAN=$mac_lan&MAC_WAN=$mac_wan&MAC_RADIO1=$mac_radio1&MAC_RADIO2=$mac_radio2&Patrimonio=$patrimonio&Id_status=1&Marca=Motorola&Modelo=AP5131&&Serial=000&Descricao=\"$descricao\"" & 
echo ""
echo "Aperte ENTER para fazer Upload do Arquivo de Configuração..."
read enter
curl http://$ip_default/cgi-bin/upload.cgi -F password="$senha" -F cfgfile="@$arquivo" 

echo ""
echo "Mude o cabo de rede para a interface LAN. Pingando novo IP..."
ping $ip



