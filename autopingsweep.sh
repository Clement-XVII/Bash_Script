echo -ne "Essential tools: checking... "
app=$(which ipcalc | cut -c-5)

if [[ $app == '/usr/' ]];
then
    echo -e "OK\r"
else
    echo "error"
    echo "Do you wish to install this program?"
    echo "0.  Exit"
    echo "1.  Install ipcalc on Ubuntu"
    echo "2.  Install ipcalc on Arch"
    echo "3.  Install ipcalc on Fedora"
    read -rp "> " dos_option
	case ${dos_option} in
		0)
			exit
		;;
		1)
			sudo apt install ipcalc
		;;
		2)
			sudo pacman -S ipcalc
		;;
		3)
			sudo dnf -y install ipcalc
		;;
		*)
			echo "Please answer."
		;;
	esac

fi




#ipcalc 192.168.1.1/24
#net=$(ip route show | cut -f1 -d\ | grep -v default);
#echo $net;
gateway=$(ip route show | cut -f1 -d\ | grep -v default);
net=$(echo $gateway | awk '{print $1}');
#ipcalc $net

#ipcalc $net | grep Broadcast | cut -d'\' -f 2;                 if [$gateway == $net]
min=$(ipcalc $net | grep HostMin | awk '{print $2}');
max=$(ipcalc $net | grep HostMax | awk '{print $2}');


#echo "$((${-+"(${max//./"+256*("}))))"}&255))"
a="$((${-+"(${max//./"+256*("}))))"}>>8&255))"
b="$((${-+"(${max//./"+256*("}))))"}>>16&255))"
c="$((${-+"(${max//./"+256*("}))))"}>>24&255))"

mina="$((${-+"(${min//./"+256*("}))))"}>>8&255))"
minb="$((${-+"(${min//./"+256*("}))))"}>>16&255))"
minc="$((${-+"(${min//./"+256*("}))))"}>>24&255))"

class=$((${-+"(${net//./"+256*("}))))"}&255))


if [[ $class -lt '128' ]];
then
	echo "Classe A"
    addra=$(echo $net | cut -d '.' -f 1)
    for i in $(seq $minc $c);
    do
        for j in $(seq $minb $b);
        do
            for l in $(seq $mina $a);
            do
            ping $addra.$l.$j.$i -c1 -W1 & done done done | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//"
	
elif [[ $class -ge '128' ]] && [[ $class -lt '192' ]];
then
	echo "Classe B"
    addrb=$(echo $net | cut -d '.' -f 1,2)
    for i in $(seq $minc $c);
    do
        for j in $(seq $minb $b);
        do
            ping $addrb.$j.$i -c1 -W1 & done done | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//"

elif [[ $class -ge '192' ]] && [[ $class -lt '224' ]];
then 
    echo "Classe C"
    addrc=$(echo $net | cut -d '.' -f 1,2,3)
    for i in $(seq $minc $c);
    do
        ping $addrc.$i -c1 -W1 & done | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//"
fi








