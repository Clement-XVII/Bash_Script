for ip in $(cat $1)

do
    ping $ip -c 1 -t 1 &> /dev/null
    if [ $? -ne 0 ]; then

        echo -e $(tput setaf 7)--------------------------------------$(tput sgr 0);
        echo -e $(tput setaf 1)$ip OFFLINE $(tput sgr 0);

        else

        echo -e $(tput setaf 7)--------------------------------------$(tput sgr 0);
        echo -e $(tput setaf 2)$ip ONLINE $(tput sgr 0);
	ssh root@$ip "hostname -I && apt update -y && apt upgrade -y"
    fi
done
