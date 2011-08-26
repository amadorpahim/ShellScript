#!/bin/bash

##Variaveis###########
vms="$(xe vm-list | grep "name-label" | grep -v "Control domain" | tr -s " " | cut -d " " -f 5)"
dirBack=/backup
#######################

rm -f $dirBack/* 

for vm in $(echo $vms)
do

time=$(date --date "now" +%d_%m_%y_%H:%M)
snapName=$vm-bk-$time

############
## Passo 1 - Criando Snapshot e pegando o UID
ID=$(xe vm-snapshot vm=$vm new-name-label=$snapName &&
        {
        logger -t "XenBackup" -s "$vm - OK Passo 1"
        }||{
        logger -t "XenBackup" -s "$vm - ERR Passo 1"
        echo 1
        })

if [ "$ID" == "1" ]
then
        exit 1
fi

## Passo 2 - Transformando o Snapshot em vm
xe template-param-set is-a-template=false uuid=$ID &&
        {
        logger -t "XenBackup" -s "$vm - OK Passo 2"
        }||{
        logger -t "XenBackup" -s "$vm - ERR Passo 2"
        exit 2
        }

### Passo 3 - Exportando vm para dir de backup
xe vm-export vm=$snapName  filename=$dirBack/$snapName
        {
        logger -t "XenBackup" -s "$vm - OK Passo 3"
        }||{
        logger -t "XenBackup" -s "$vm - ERR Passo 3"
        exit 3
        }

### Passo 4 - Removendo snap
xe vm-uninstall vm=$snapName force=true
        {
        logger -t "XenBackup" -s "$vm - OK Passo 4"
        }||{
        logger -t "XenBackup" -s "$vm - ERR Passo 4"
        exit 4
        }

### Passo 5 - Compactando vm
gzip $dirBack/$snapName
       {
       logger -t "XenBackup" -s "$vm - OK Passo 5"
       }||{
       logger -t "XenBackup" -s "$vm - ERR Passo 5"
       exit 5
       }

done
exit 0
