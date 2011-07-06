#!/bin/bash
# Script para rotação de logs gerados diariamente em diretórios diferentes.
# Útil usando o syslog-ng, separando o log por diretórios/dia.


DiaAtual=$(date --date="today" +%d)
DataApagar=$(date --date "2 month ago" +%Y/%m)

[ "$DiaAtual" == "01" ] && {
	rm -rf /var/logserver/*/$DataApagar
}



data=$(date --date="1 day ago" +%Y/%m/%d)
data2=$(date --date="1 day ago" +%Y_%m_%d)

dir=/var/logserver
dir_backup=/backup

for i in $(ls $dir)
do
	if [ ! -d $dir_backup/$i ]
	then
		mkdir $dir_backup/$i
	fi	
	if [ ! -d $dir_backup/$i/$(date --date="1 day ago" +%Y) ]
	then
		mkdir $dir_backup/$i/$(date --date="1 day ago" +%Y)	
	fi	
	if [ ! -d $dir_backup/$i/$(date --date="1 day ago" +%Y)/$(date --date="1 day ago" +%m) ]
	then
		mkdir $dir_backup/$i/$(date --date="1 day ago" +%Y)/$(date --date="1 day ago" +%m)
	fi
	if [ ! -d $dir_backup/$i/$(date --date="1 day ago" +%Y)/$(date --date="1 day ago" +%m)/$(date --date="1 day ago" +%d) ]
	then
		mkdir $dir_backup/$i/$(date --date="1 day ago" +%Y)/$(date --date="1 day ago" +%m)/$(date --date="1 day ago" +%d)
	fi
	cd $dir/$i/$data/ && tar -cjf /backup/$i/$data/files.tar.bz2 *
done

