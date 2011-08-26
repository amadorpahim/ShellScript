#!/bin/bash

# Servidores do POOL que serao gerenciados
## O server[0] tem prioridade no modo powersave por ser o home desse script
## VMs sem "Home Server" definido serao alocadas no server[0] por default

server[0]="xtriton01"
server[1]="xtriton02"
server[2]="xtriton03"
server[3]="xtriton04"
server[4]="xtriton05"


#Maquinas virtuais que serao gerenciadas

vm[0]="vtriton01"
vm[1]="vtriton02"
vm[2]="vtriton03"
vm[3]="vtriton04"
vm[4]="vtriton10"
vm[5]="vtriton11"
vm[6]="vtriton12"
vm[7]="vtriton14"
vm[8]="vtriton50"
vm[9]="vtriton51"



poweroff()
{
	read -p "Are you sure? (s/n): " sure
	if [ $sure == "s" ]
	then
        for PwMachine in $(echo ${vm[*]})
                do
                        PwVmUuid=$(xe vm-list name-label=$PwMachine | grep "^uuid" | sed 's/ //g' | cut -d ":" -f 2)
                        PwVmPowerState=$(xe vm-param-get uuid=$PwVmUuid param-name=power-state)
                        if [ "$PwVmPowerState" == "running" ]
                                then
                                        echo -n "Desligando VM $PwMachine... "
                                        echo "xe vm-shutdown vm=$PwMachine && echo OK || exit 10"
                        fi

        done
	for PwHost in $(echo ${server[*]})
		do
			
			echo "Desligando host $PwHost"
                        echo "xe host-shutdown host=$PwHost && echo OK || exit 2"
	done

	else
		echo Aborted
	fi

}



vmpoweroff()
{
	for SdMachine in $(echo ${vm[*]})
		do
			SdVmUuid=$(xe vm-list name-label=$SdMachine | grep "^uuid" | sed 's/ //g' | cut -d ":" -f 2)
        		SdVmPowerState=$(xe vm-param-get uuid=$SdVmUuid param-name=power-state)
			if [ "$SdVmPowerState" == "running" ]
        			then
					echo -n "Desligando VM $SdMachine... " 
					xe vm-shutdown vm=$SdMachine && echo OK || exit 10
			fi
			
	done

}








default()
{
for DfMachine in $(echo ${vm[*]})
do
        DfVmUuid=$(xe vm-list name-label=$DfMachine | grep "^uuid" | sed 's/ //g' | cut -d ":" -f 2)
	DfVmPowerState=$(xe vm-param-get uuid=$DfVmUuid param-name=power-state)
        DfVmAffinity=$(xe vm-param-get uuid=$DfVmUuid param-name=affinity)
	DfVmResidentOn=$(xe vm-param-get uuid=$DfVmUuid param-name=resident-on)


	if [ "$DfVmAffinity" == "<not in database>" ]
	then
		DfVmHost=${server[0]}	
		DfVmAffinity=$(xe host-list name-label="$DfVmHost" | grep "^uuid" | sed 's/ //g' | cut -d ":" -f 2)
		echo "$DfMachine nao tem \"Home Server\" definido..."			
	else
		DfVmHost=$(xe host-param-get uuid=$DfVmAffinity param-name=name-label)
	fi
	if [ "$DfVmPowerState" == "running" ]
        then
		if [ "$DfVmResidentOn" == "$DfVmAffinity" ]
		then
			echo "$DfMachine jah esta no servidor $DfVmHost."			
		else
			echo -n "Levando $DfMachine de volta pra casa ($DfVmHost)... "
                	xe vm-migrate vm=$DfMachine host=$DfVmHost && echo OK || exit 3
		fi
	elif [ "$DfVmPowerState" == "halted" ]
	then
		echo -n "Ligando $DfMachine em $DfVmHost... "
		xe vm-start vm=$DfMachine on=$DfVmHost && echo OK || exit 1
	fi	

done
}

xpowersave()
{
	echo TODO
}


powersave()
{
cont=0
for srv in $(echo ${server[*]})
do
	SrvUuid=$(xe host-list name-label="$srv" | grep "^uuid" | sed 's/ //g' | cut -d ":" -f 2)
	SrvMemTotal=$(xe host-param-get uuid=$SrvUuid param-name=memory-total)
	
	arrayRecursos[$cont]="$SrvMemTotal,$srv,$SrvUuid"
	let cont++
done


serverOrdenado[0]=$(echo "${arrayRecursos[0]}" | cut -d "," -f 2,3)

cont=1
for recurso in $(echo "${arrayRecursos[*]:1}" | tr " " "\n" | sort -r -g)
do
	serverOrdenado[$cont]=$(echo $recurso | cut -d "," -f 2,3)
	let cont++
done

cont=0

for machine in $(echo ${vm[*]})
do
	VmUuid=$(xe vm-list name-label=$machine | grep "^uuid" | sed 's/ //g' | cut -d ":" -f 2)
        VmMemTotal=$(xe vm-param-get uuid=$VmUuid param-name=memory-actual)
	
	arrayRecursosVm[$cont]="$VmMemTotal,$machine,$VmUuid"
	let cont++
done

cont=0

for recursoVm in $(echo "${arrayRecursosVm[*]}" | tr " " "\n" | sort -r -g)
do
        vmOrdenado[$cont]=$(echo $recursoVm)
        let cont++
done


for vmachine in $(echo ${vmOrdenado[*]})
do
	VmName=$(echo $vmachine | cut -d "," -f 2)
	VmUuid=$(echo $vmachine | cut -d "," -f 3)
	VmMemTotal=$(echo $vmachine | cut -d "," -f 1)
	VmResidentOn=$(xe vm-param-get uuid=$VmUuid param-name=resident-on)
	VmPowerState=$(xe vm-param-get uuid=$VmUuid param-name=power-state)

	if [ "$VmPowerState" == "running" ]
	then		

	for i in $(echo ${serverOrdenado[*]})
	do
		SrvName=$(echo $i | cut -d "," -f 1)
		SrvUuid=$(echo $i | cut -d "," -f 2)
		SrvMemFree=$(xe host-param-get uuid=$SrvUuid param-name=memory-free)

		#echo "SrvMemFree: $SrvMemFree"
		#echo "VmMemTotal: $VmMemTotal"

		if [ "$VmResidentOn" == "$SrvUuid" ]
		then
			echo "Vm: $VmName jah roda no servidor $SrvName."
			break
		elif [ "$SrvMemFree" -gt $VmMemTotal ]
		then
			echo -n "Vm: $VmName pode rodar no servidor $SrvName. Migrando... "
			xe vm-migrate vm=$VmName host=$SrvName && echo OK || exit 2
			break
		else
			echo "Opa! Vm: $VmName NAO pode rodar no servidor $SrvName."
		fi
	done

	else
		echo "Vm: $VmName nao esta ligada. Nada feito."	
	fi


done 

cont=0
for virtmachine in $(echo ${vm[*]})
do
	VmUuid=$(xe vm-list name-label=$virtmachine | grep "^uuid" | sed 's/ //g' | cut -d ":" -f 2)
	VmPlace[$cont]=$(xe vm-param-get uuid=$VmUuid param-name=resident-on)
	let cont++
done
	
cont=0
for srver in $(echo ${server[*]})
do
        Place[$cont]=$(xe host-list name-label="$srver" | grep "^uuid" | sed 's/ //g' | cut -d ":" -f 2)
	let cont++
done

echo "Desligando servidores que ficaram sem nenhuma VM..."
cont=0
for linha in $(echo ${Place[*]} | tr " " "\n")
do
	res=""
	res=$(echo ${VmPlace[*]} | tr " " "\n" | grep $linha)
	Host=$(xe host-param-get uuid=$linha param-name=name-label)
	if [ -n "$res" ]
		then
			echo Nao desligue $Host
		else
			#echo Pode desligar $Host
			echo "Desabilitando host $Host"
                        xe host-disable host=$Host && echo OK || exit 2
                        echo "Desligando host $Host"
                        xe host-shutdown host=$Host && echo OK || exit 2
	fi
done


}



case $1 in
	poweroff)
	poweroff
	;;
	vmpoweroff)
	vmpoweroff
	;;
	powersave)
	powersave
	;;
	xpowersave)
	xpowersave
	;;
	default)
	default
	;;
	*)
	echo "
OPTIONS:

default
        Migrate VMs to his \"Home Servers\"
	VMs without \"Home Server\" defined will be migrated to \"server[0]\"

powersave
        Allocate VMs using minimun of hosts. Shutdown unused hosts.

vmpoweroff
        Shutdown all VMs.

poweroff
        Shutdown all VMs and all Hosts.
"
	;;
esac
