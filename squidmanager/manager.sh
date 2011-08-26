# !/bin/bash
# Squid Manager
# Amador Pahim - amador@pahim.org
# Script para gerenciar funcoes basicas de ACLs do squid
# Copyright (C) 2009  Amador Pahim
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#DIRETORIOS DO SISTEMA
DIRGRUPOIP=/etc/squid/manager/grupoip
DIRGRUPOSITE=/etc/squid/manager/gruposite
DIRIPSITE=/etc/squid/manager/ipsite
DIRSQUID=/etc/squid
DIRMANAGER=/etc/squid/manager
DIRDEFAULTS=/etc/squid/manager/defaults

#NOME DO BINARIO DO SQUID
SQUIDBIN=squid

#############################################################################
MenuPrincipal()
{
menu1=""
menu1=$(dialog  --stdout --title " Squid Manager " --menu "Escolha a opção desejada:" 0 0 0 \
	"1 Grupo IP"			"Gerencia grupos de IPs" \
	"2 Grupo Site"			"Gerencia grupos de Sites" \
	"3 IP x Site"			"Relaciona Grupos IPs com Grupos Sites" \
	"4 Salvar"			"Atualiza squid.conf" \
	"----------------------"	"-------------------------------------" \
	"5 squid -k reconfigure"	"Aplica novo squid.conf" \
	"6 squid stop"			"Para Squid" \
	"7 squid start"			"Inicia squid" \
	"8 squid restart"		"Reinicia squid" \
	"9 squid log"			"Monitora Log do Squid" \
	"----------------------"	"-------------------------------------" \
	"0 SAIR"			"Sai do Sistema" | cut -d " " -f 1) 
if [ ! -z "$menu1" ] 
then
	case "$menu1" in
		1)
		GrupoIp;
		;;
		2)
		GrupoSite;
		;;
		3)
		IpSite;
		;;
		4)
		SquidConf;
		;;
		5)
		sudo $SQUIDBIN -k reconfigure;
		sleep 1;
		if [ "$?" = "0" ]
		then
			echo OK
		else
			echo Erro
		fi
		sleep 2;
		MenuPrincipal;
		;;
		6)
		sudo /etc/init.d/$SQUIDBIN stop;
		sleep 1;
		if [ "$?" = "0" ]
		then
			echo OK
		else
			echo Erro
		fi
		sleep 2;
		MenuPrincipal;
		;;
		7)
		sudo /etc/init.d/$SQUIDBIN start;
		sleep 1;
		if [ "$?" = "0" ]
		then
			echo OK
		else
			echo Erro
		fi
		sleep 2;
		MenuPrincipal;
		;;
		8)
		sudo /etc/init.d/$SQUIDBIN restart;
		sleep 1;
		if [ "$?" = "0" ]
		then
			echo OK
		else
			echo Erro
		fi
		sleep 2;
		MenuPrincipal;
		;;
		9)
		SquidLog;
		MenuPrincipal;
		;;
		0)
		exit 0;
		;;
		*)
		MenuPrincipal;
		;;
	esac
else
	echo Bye.
fi
}

#############################################################################
GrupoIp()
{
menu2=""
menu2=$(dialog --stdout --title 'GRUPOS DE IPs' --menu "Escolha" 0 0 0 \
			"1 Criar"	"Cria novo grupo de IPs" \
			"2 Editar"	"Edita grupo de IPs existente"  \
			"3 Remover"	"Apaga grupo de IPs existente"  \
			"4 VOLTAR"	"Volta para Menu Principal"  \
			"9 SAIR"	"Sai do sistema" | cut -d " " -f 1)

if [ ! -z "$menu2" ]
then
	case "$menu2" in
		1)
		CriaGrupoIp;
		;;
		2)
		EditaGrupoIp;
		;;
		3)
		RemoveGrupoIp;
		;;
		4)
		MenuPrincipal;
		;;
		9)
		exit 0;
		;;
	esac
else
	MenuPrincipal
fi
}

#############################################################################
CriaGrupoIp()
{
aclDefaultGrupoIp=""
nomeCriaGrupoIp=""
nomeCriaGrupoIp=$(dialog --stdout --inputbox "Defina um nome para o Grupo:" 0 0 )
if [ ! -z $nomeCriaGrupoIp  ]
then
	> $DIRGRUPOIP/$nomeCriaGrupoIp
	if [ "$?" = "0" ] 
	then
		dialog  --title "AVISO" --msgbox "Grupo $nomeCriaGrupoIp criado." 0 0
	else
		echo erro criando grupo ip.
		exit 1
	fi
	aclDefaultGrupoIp=$(dialog --stdout --no-cancel --title "ACL default" --menu \
		"Qual eh a politica default desse grupo?" 0 0 0 \
		"1 Bloqueado"	"Definir default como bloqueado" \
		"2 Liberado"	"Definir default como liberado" | cut -d " " -f 1)
	echo "$aclDefaultGrupoIp" > $DIRDEFAULTS/$nomeCriaGrupoIp
	if $(dialog --stdout --yesno "Deseja editar o novo grupo agora?" 0 0 )
	then
		pico "$DIRGRUPOIP"/"$nomeCriaGrupoIp"
		MenuPrincipal
	else
		MenuPrincipal
	fi
else
	dialog  --title "AVISO" --msgbox "Nenhuma alteração foi efetuada." 0 0
	GrupoIp
fi
}

#############################################################################
EditaGrupoIp()
{
arquivosEditaGrupoIp=""
arquivosEditaGrupoIp=$(ls $DIRGRUPOIP)
nomeEditaGrupoIp=""
linha=""
linhaEditaGrupoIp=""
testeLibBloq=""


for linhaEditaGrupoIp in $(echo $arquivosEditaGrupoIp)
do
	testeLibBloq=$(cat $DIRDEFAULTS/$linhaEditaGrupoIp)
	if [ "$testeLibBloq" = "1" ]
	then
		linha="$linha $linhaEditaGrupoIp Bloqueado "
	else
		linha="$linha $linhaEditaGrupoIp Liberado "
	fi
done

nomeEditaGrupoIp=$(dialog --stdout --menu "Escolha Grupos IP que deseja editar" 0 0 0 \
		$(echo $linha)) 

if [ ! -z "$nomeEditaGrupoIp"  ]
then
	pico "$DIRGRUPOIP"/"$nomeEditaGrupoIp"
	GrupoIp
else
	GrupoIp
fi
}

#############################################################################
RemoveGrupoIp()
{
arquivosIp=""
arquivosRemoveGrupoIp=""
arquivosRemoveGrupoIp=$(ls $DIRGRUPOIP)
nomeRemoveGrupoIp=""
linha=""
linhaRemoveGrupoIp=""
testeLibBloq=""

if [ ! -z "$arquivosRemoveGrupoIp" ]
then
	for linhaRemoveGrupoIp in $(echo $arquivosRemoveGrupoIp)
	do
		testeLibBloq=$(cat $DIRDEFAULTS/$linhaRemoveGrupoIp)
		if [ "$testeLibBloq" = "1" ]
		then
			linha="$linha $linhaRemoveGrupoIp Bloqueado OFF "
		else
			linha="$linha $linhaRemoveGrupoIp Liberado OFF "
		fi
	done

	nomeRemoveGrupoIp=$(dialog --stdout --checklist "Escolha Grupos IP que serao removidos" 0 0 0 \
			$(echo $linha) | tr "\"" " ")
echo $nomeRemoveGrupoIp
	if [ ! -z "$nomeRemoveGrupoIp"  ]
	then
		if $(dialog --stdout --yesno "Deseja remover as listas selecionadas?" 0 0 )
		then
			for i in $(echo $nomeRemoveGrupoIp)
			do
				rm -f "$DIRGRUPOIP"/"$i"
				rm -f "$DIRIPSITE"/"$i"
				rm -f "$DIRDEFAULTS"/"$i"
				grep -v "$i:" $DIRMANAGER/relacoes > $DIRMANAGER/relacoes.temp 
				cat $DIRMANAGER/relacoes.temp > $DIRMANAGER/relacoes
				arquivosIp=$(ls $DIRGRUPOIP)
				if [ -z "$arquivosIp" ]
				then
					> $DIRMANAGER/relacoes
				fi
			done
			dialog  --title "AVISO" --msgbox "Grupo(s) $nomeRemoveGrupoIp removido(s)." 0 0
			MenuPrincipal
		else
			dialog  --title "AVISO" --msgbox "Nenhuma alteração foi efetuada." 0 0
			GrupoIp
		fi
	else
		GrupoIp
	fi
fi
GrupoIp
}

##########################################################################################################
GrupoSite()
{
menu3=""
menu3=$(dialog --stdout --title 'GRUPOS DE SITES' --menu "Escolha" 0 0 0 \
			"1 Criar"	"Cria novo grupo de Sites" \
			"2 Editar"	"Edita grupo de Sites existente"  \
			"3 Remover"	"Apaga grupo de Sites existente"  \
			"4 VOLTAR"	"Volta para Menu Principal"  \
			"9 SAIR"	"Sai do sistema" | cut -d " " -f 1)

if [ ! -z "$menu3" ]
then
	case "$menu3" in
		1)
		CriaGrupoSite;
		;;
		2)
		EditaGrupoSite;
		;;
		3)
		RemoveGrupoSite;
		;;
		4)
		MenuPrincipal;
		;;
		9)
		exit 0;
		;;
	esac
else
	MenuPrincipal
fi
}

#############################################################################
CriaGrupoSite()
{
nomeCriaGrupoSite=""

nomeCriaGrupoSite=$(dialog --stdout --inputbox "Defina um nome para o Grupo:" 0 0 )

if [ ! -z $nomeCriaGrupoSite  ]
then
	> $DIRGRUPOSITE/$nomeCriaGrupoSite
	if [ "$?" = "0" ] 
	then
		dialog  --title "AVISO" --msgbox "Grupo $nomeCriaGrupoSite criado." 0 0
	else
		echo erro criando grupo site.
		exit 1
	fi
	if $(dialog --stdout --yesno "Deseja editar o novo grupo agora?" 0 0 )
	then
		pico "$DIRGRUPOSITE"/"$nomeCriaGrupoSite"
		GrupoSite
	else
		GrupoSite
	fi
else
	dialog  --title "AVISO" --msgbox "Nenhuma alteração foi efetuada." 0 0
	GrupoSite
fi
}

#############################################################################
EditaGrupoSite()
{
arquivosEditaGrupoSite=""
arquivosEditaGrupoSite=$(ls $DIRGRUPOSITE)
nomeEditaGrupoSite=""

nomeEditaGrupoSite=$(dialog --stdout --menu "Escolha Grupos IP que deseja editar" 0 0 0 \
		$(echo $arquivosEditaGrupoSite | sed 's/ / '.' /g' | sed 's/$/ ./' )) 

if [ ! -z "$nomeEditaGrupoSite"  ]
then
	pico "$DIRGRUPOSITE"/"$nomeEditaGrupoSite"
	GrupoSite
else
	GrupoSite
fi
}

#############################################################################
RemoveGrupoSite()
{
arquivosRemoveGrupoSite=""
arquivosRemoveGrupoSite=$(ls $DIRGRUPOSITE)
nomeRemoveGrupoSite=""

nomeRemoveGrupoSite=$(dialog --stdout --checklist "Escolha Grupos de Sites que serao removidos" 0 0 0 \
		$(echo $arquivosRemoveGrupoSite | sed 's/ / . OFF /g' | sed 's/$/ . OFF/' )| sed 's/\"//g')

if [ ! -z "$nomeRemoveGrupoSite"  ]
then
	if $(dialog --stdout --yesno "Deseja remover as listas selecionadas?" 0 0 )
	then
		for i in $(echo $nomeRemoveGrupoSite)
		do
			rm -f "$DIRGRUPOSITE"/"$i"
			grep -v ":$i" $DIRMANAGER/relacoes > $DIRMANAGER/relacoes.temp 
			cat $DIRMANAGER/relacoes.temp > $DIRMANAGER/relacoes
		done
		dialog  --title "AVISO" --msgbox "Grupo(s) $nomeRemoveGrupoSite removido(s)." 0 0
		MenuPrincipal
	else
		dialog  --title "AVISO" --msgbox "Nenhuma alteração foi efetuada." 0 0
		GrupoSite
	fi
else
	GrupoSite
fi
}
############################################################
SquidConf()
{
> $DIRMANAGER/acls.temp
> $DIRMANAGER/access.temp
> $DIRMANAGER/access.default
> $DIRMANAGER/squid.conf.gerado

checaDefault=""
grupoip=""
gruposite=""
accessManager=""
aclsManager=""
accessManagerDefaults=""

for linha in $(cat $DIRMANAGER/relacoes)
do
	grupoip=$(echo $linha | cut -d ":" -f 1) 
	gruposite=$(echo $linha | cut -d ":" -f 2) 

	echo "acl $grupoip src \"$DIRGRUPOIP/$grupoip\"" >> $DIRMANAGER/acls.temp 
	echo "acl $gruposite url_regex \"$DIRGRUPOSITE/$gruposite\"" >> $DIRMANAGER/acls.temp

	checaDefault=$(cat "$DIRDEFAULTS/$grupoip")
	if [ "$checaDefault" = "1" ]
	then
	echo "http_access allow $grupoip $gruposite" >> $DIRMANAGER/access.temp
	else
	echo "http_access deny $grupoip $gruposite" >> $DIRMANAGER/access.temp
	fi

done
accessManager=$(cat $DIRMANAGER/access.temp | sort -u)
aclsManager=$(cat $DIRMANAGER/acls.temp | sort -u)

grupo=""
listaGrupoIp=""
listaGrupoIp=$(ls "$DIRGRUPOIP")

for grupo in $(echo $listaGrupoIp)
do
	checaDefault=$(cat "$DIRDEFAULTS/$grupo")
	if [ "$checaDefault" = "1" ]
	then
	echo "http_access deny $grupo" >> $DIRMANAGER/access.default
	else
	echo "http_access allow $grupo" >> $DIRMANAGER/access.default
	fi
done

accessManagerDefaults=$(cat $DIRMANAGER/access.default)

### SQUID.CONF
echo "# Gerado em $(date)" >> $DIRMANAGER/squid.conf.gerado
echo 'http_port 3128' >> $DIRMANAGER/squid.conf.gerado
echo 'icp_port 3130' >> $DIRMANAGER/squid.conf.gerado
echo 'hierarchy_stoplist cgi-bin ?'  >> $DIRMANAGER/squid.conf.gerado
echo 'acl QUERY urlpath_regex cgi-bin \?' >> $DIRMANAGER/squid.conf.gerado
echo 'cache deny QUERY' >> $DIRMANAGER/squid.conf.gerado
echo 'refresh_pattern ^ftp:		1440	20%	10080' >> $DIRMANAGER/squid.conf.gerado
echo 'refresh_pattern ^gopher:	1440	0%	1440' >> $DIRMANAGER/squid.conf.gerado
echo 'refresh_pattern .		0	20%	4320' >> $DIRMANAGER/squid.conf.gerado
echo 'acl all src 0.0.0.0/0.0.0.0' >> $DIRMANAGER/squid.conf.gerado
echo 'acl manager proto cache_object' >> $DIRMANAGER/squid.conf.gerado
echo 'acl localhost src 127.0.0.1/255.255.255.255' >> $DIRMANAGER/squid.conf.gerado
echo 'acl to_localhost dst 127.0.0.0/8' >> $DIRMANAGER/squid.conf.gerado
echo 'acl SSL_ports port 443' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 80		# http' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 21		# ftp' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 443		# https' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 70		# gopher' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 210		# wais' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 1025-65535	# unregistered ports' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 280		# http-mgmt' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 488		# gss-http' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 591		# filemaker' >> $DIRMANAGER/squid.conf.gerado
echo 'acl Safe_ports port 777		# multiling http' >> $DIRMANAGER/squid.conf.gerado
echo 'acl CONNECT method CONNECT' >> $DIRMANAGER/squid.conf.gerado
echo '#######################' >> $DIRMANAGER/squid.conf.gerado
echo '' >> $DIRMANAGER/squid.conf.gerado
echo '##### ACLS MANAGER ####' >> $DIRMANAGER/squid.conf.gerado
echo "$aclsManager" >> $DIRMANAGER/squid.conf.gerado
echo '' >> $DIRMANAGER/squid.conf.gerado
echo '##### ACCESS MANAGER ####' >> $DIRMANAGER/squid.conf.gerado
echo "$accessManager" >> $DIRMANAGER/squid.conf.gerado
echo '' >> $DIRMANAGER/squid.conf.gerado
echo '##### ACCESS DEFAULTS ########' >> $DIRMANAGER/squid.conf.gerado
echo "$accessManagerDefaults" >> $DIRMANAGER/squid.conf.gerado
echo '' >> $DIRMANAGER/squid.conf.gerado
echo '#######################' >> $DIRMANAGER/squid.conf.gerado
echo 'http_access allow manager localhost' >> $DIRMANAGER/squid.conf.gerado
echo 'http_access deny manager' >> $DIRMANAGER/squid.conf.gerado
echo 'http_access deny !Safe_ports' >> $DIRMANAGER/squid.conf.gerado
echo 'http_access deny CONNECT !SSL_ports' >> $DIRMANAGER/squid.conf.gerado
echo 'http_access allow localhost' >> $DIRMANAGER/squid.conf.gerado
echo 'http_reply_access allow all' >> $DIRMANAGER/squid.conf.gerado
echo 'icp_access allow all' >> $DIRMANAGER/squid.conf.gerado
echo 'coredump_dir /var/spool/squid' >> $DIRMANAGER/squid.conf.gerado

cat $DIRMANAGER/squid.conf.gerado > $DIRSQUID/squid.conf
dialog --title squid.conf --textbox $DIRSQUID/squid.conf 0 0	
MenuPrincipal
}

#############################################################################
IpSite()
{
arquivosIp=""
var=""
linha=""

arquivosIp=$(ls $DIRGRUPOIP)
if [ -z "$arquivosIp" ]
then
	> $DIRMANAGER/relacoes
fi

arquivosSite=""
arquivosSite=$(ls $DIRGRUPOSITE)
nomeGrupoIp=""
linha=""
linhaIpSiteGrupoIp=""
testeLibBloq=""


for linhaIpSiteGrupoIp in $(echo $arquivosIp)
do
	testeLibBloq=$(cat $DIRDEFAULTS/$linhaIpSiteGrupoIp)
	if [ "$testeLibBloq" = "1" ]
	then
		linha="$linha $linhaIpSiteGrupoIp Bloqueado "
	else
		linha="$linha $linhaIpSiteGrupoIp Liberado "
	fi
done

nomeGrupoIp=$(dialog --stdout --menu "Escolha Grupos IP que deseja manipular" 0 0 0 \
	$(echo $linha)) 

linha=""
if [ ! -z "$nomeGrupoIp" ]
then
	> $DIRMANAGER/relacoes
	for x in $(echo $arquivosSite)
	do
		linha="$linha $x . "
		var="$(grep $x $DIRIPSITE/$nomeGrupoIp)"
		if [ ! -z "$var" ]
		then
			linha="$linha ON"
		else
			linha="$linha OFF"
		fi
	done

	checaDefault=""
	checaDefault=$(cat "$DIRDEFAULTS/$nomeGrupoIp")
	if [ "$checaDefault" = "1" ]
	then
		msg="BLOQUEADO"
		msg2="LIBERAR"
	else
		msg="LIBERADO"
		msg2="BLOQUEAR"
	fi

grupoSiteParaGrupoIp=$(dialog --stdout --no-cancel --checklist \
	"Por default, o grupo de IPs $nomeGrupoIp eh $msg. \
	Escolha os grupos de Sites que voce deseja $msg2" \
	0 0 0 $(echo $linha) | tr "\"" " ") 

echo "$grupoSiteParaGrupoIp" > $DIRIPSITE/$nomeGrupoIp
for i in $(ls $DIRIPSITE)
do
	for j in $(cat $DIRIPSITE/$i)
	do
		echo $i:$j >> $DIRMANAGER/relacoes
	done
done

fi

MenuPrincipal
}

#############################################################################
SquidLog()
{
tail -f /var/log/$SQUIDBIN/access.log > $DIRMANAGER/temp/out & \ 
	dialog --title "/var/log/$SQUIDBIN/access.log" --tailbox \
	$DIRMANAGER/temp/out 0 0
}

##### Inicia o programa
MenuPrincipal


