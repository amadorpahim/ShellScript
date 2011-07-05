#!/bin/bash
#
# Script para criação/remoção de usuários no Linux.
# 
#
# USO:
## Adicionar usuário
### ./LinuxUsers.sh -a -b /bin/bash -h /home/username -p senha -u username
## Remover usuário
### ./LinuxUsers.sh -d username


Add(){

# Recebe parâmetros adicinais para cadastro do usuário (-b, -h, -p e -u)
while getopts ":b:h:p:u:" Opt
do
	case $Opt in
                b)
                        Bash="$OPTARG"
                ;;
                h)
                        Home="$OPTARG"
                ;;
                p)
                        Password="$OPTARG"
                ;;
		u)
			User="$OPTARG"
		;;
		\?)
			echo "Opção inválida: -$OPTARG"
			exit 1
		;;
		:)
			echo "Opção -$OPTARG necessita argumento."
			exit 1
		;;
	esac
done

# Solicitar o shell, caso o "-s" não tenha sido usado
while [ ! $Bash ] 
do
	read -p "Informe o shell: " Bash
done

# Solicitar o home, caso o "-h" não tenha sido usado
while [ ! $Home ] 
do
	read -p "Informe o home: " Home
done

# Solicitar a senha, caso o "-p" não tenha sido usado
while [ ! $Password ] 
do
	read -s -p "Informe a senha: " Password
done

# Solicitar o username, caso o "-u" não tenha sido usado
while [ ! $User ] 
do
	read -p "Informe o usuario: " User
done

# Adicionando o usuário e definindo a senha
useradd -s "$Bash" -d "$Home" "$User" && {
	echo "Usuário $User criado com sucesso"
	echo "$Password" | passwd --stdin "$User" 
} || {
	echo "Erro criando usuário $User"
}


}

Remove(){

# Recebe parâmetro adicional para remoção do usuário (-u)
while getopts ":u:" Opt
do
        case $Opt in
                u)
                        User="$OPTARG"
                ;;
                \?)
                        echo "Opção inválida: -$OPTARG"
                        exit 1
                ;;
                :)
                        echo "Opção -$OPTARG necessita argumento."
                        exit 1
                ;;
        esac
done

# Solicitar o username, caso o "-u" não tenha sido usado
while [ ! $User ] 
do
        read -p "Informe o usuario: " User
done

# Removendo o usuário
userdel -r $User  && {
        echo "Usuário $User removido com sucesso"
} || {  
        echo "Erro removendo usuário $User"
} 

}


# Recebe opções "-a" ou "-d" para chamar a função correspondente
while getopts ":ad" Opt
do
	case $Opt in
		a)
			Add $@
		;;
		d)
			Remove $@
		;;
		*)
			echo "Use $0 { -a [ -b shell | -h homedir | -p password | -u usuário ] | -d }"
	esac
done
