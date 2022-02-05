#printf "%20s %20s\n" "IP address/Name" "Status"
#printf "%20s %20s\n" "===============" "======"
for ip in $(cat $1)

do
    ping $ip -c 1 -t 1 -w 1 &> /dev/null
    if [ $? -ne 0 ]; then

        echo -e $(tput setaf 7)--------------------------------------$(tput sgr 0);
        echo -e "$(tput setaf 1)$ip OFFLINE $(tput sgr 0)";
        #printf "%20s %20s\n" "$ip" "OFFLINE"
        else

        echo -e $(tput setaf 7)--------------------------------------$(tput sgr 0);
        echo -e "$(tput setaf 2)$ip ONLINE $(tput sgr 0)";
        #printf "%20s %20s\n" "$ip" "ONLINE"
    fi
done

echo -e $(tput setaf 7)--------------------------------------$(tput sgr 0);