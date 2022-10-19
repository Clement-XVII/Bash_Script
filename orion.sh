essential_tools=(ipcalc nmap)

OPTION1="$1"
OPTION2="$2"
OPTION3="$3"

gateway_cidr=$(ip route show | cut -f1 -d\  | grep -v default)
gateway=$(echo $gateway_cidr | awk '{print $1}')
auto_min_host=$(ipcalc $gateway | grep HostMin | awk '{print $2}')
auto_max_host=$(ipcalc $gateway | grep HostMax | awk '{print $2}')

#$($(ip route show | cut -f1 -d\  | grep -v default) | awk '{print $1}')

function ip_address(){
	maxa="$((${-+"(${max//./"+256*("}))))"}>>8&255))"
	maxb="$((${-+"(${max//./"+256*("}))))"}>>16&255))"
	maxc="$((${-+"(${max//./"+256*("}))))"}>>24&255))"

	mina="$((${-+"(${min//./"+256*("}))))"}>>8&255))"
	minb="$((${-+"(${min//./"+256*("}))))"}>>16&255))"
	minc="$((${-+"(${min//./"+256*("}))))"}>>24&255))"
}

function auto_ip_address(){
	maxa="$((${-+"(${auto_max_host//./"+256*("}))))"}>>8&255))"
	maxb="$((${-+"(${auto_max_host//./"+256*("}))))"}>>16&255))"
	maxc="$((${-+"(${auto_max_host//./"+256*("}))))"}>>24&255))"

	mina="$((${-+"(${auto_min_host//./"+256*("}))))"}>>8&255))"
	minb="$((${-+"(${auto_min_host//./"+256*("}))))"}>>16&255))"
	minc="$((${-+"(${auto_min_host//./"+256*("}))))"}>>24&255))"
}

function time_loop() {

	echo -ne " "
	for ((j = 1; j <= 4; j++)); do
		echo -ne "${white_color}.${normal_color}"
		sleep 0.035
	done
}

function check_compatibility() {
	initialize_colors

	echo_blue "Essential tools: checking..."

	for i in "${essential_tools[@]}"; do
		echo -ne "${white_color}${i}${normal_color}"
		time_loop
		if ! hash "${i}" 2>/dev/null; then
			echo -ne "${red_color} Error${normal_color}"
			update_toolsok=0
			echo_white "Do you wish to install this program?"
			echo_white "0.  Exit"
			echo_white "1.  Install ipcalc on Ubuntu"
			echo_white "2.  Install ipcalc on Arch"
			echo_white "3.  Install ipcalc on Fedora"

			read -rp "> " dos_option
			case ${dos_option} in
			0)
				exit
				;;
			1)
				sudo apt install ipcalc nmap
				;;
			2)
				sudo pacman -S ipcalc nmap
				;;
			3)
				sudo dnf -y install ipcalc nmap
				;;
			*)
				echo_red "Please answer."
				;;
			esac
			echo -e "\r"
		else
			echo -e "${green_color} Ok\r${normal_color}"
		fi
		if ! hash "${i}" 2>/dev/null; then
			update_toolsok=0
		fi
	done

	#read -p "Press [Enter] key to continue..." -r
	#clear
	echo -e "\n"
}

function initialize_colors() {

	normal_color="\e[1;0m"
	green_color="\033[1;32m"
	green_color_title="\033[0;32m"
	red_color="\033[1;31m"
	red_color_slim="\033[0;031m"
	blue_color="\033[1;34m"
	cyan_color="\033[1;36m"
	brown_color="\033[1;33m"
	yellow_color="\033[1;33m"
	pink_color="\033[1;35m"
	white_color="\e[1;97m"
}

function echo_green() {

	echo -e "${green_color}""${1}" "${normal_color}"
}

function echo_red() {

	echo -e "${red_color}""${1}" "${normal_color}"
}

function echo_pink() {

	echo -e "${pink_color}""${1}" "${normal_color}"
}

function echo_white() {

	echo -e "${white_color}""${1}" "${normal_color}"
}

function echo_blue() {

	echo -e "${blue_color}""${1}" "${normal_color}"
}

function echo_brown() {

	echo -e "${brown_color}""${1}" "${normal_color}"
}

function echo_cyan() {

	echo -e "${cyan_color}""${1}" "${normal_color}"
}

function auto_ping_sweep(){
welcome
auto_ip_address


class=$((${-+"(${gateway//./"+256*("}))))"}&255))

	if [[ $class -lt '128' ]]; then
	echo "Classe A"
	addra=$(echo $gateway | cut -d '.' -f 1)
	for i in $(seq $minc $maxc); do
		for j in $(seq $minb $maxb); do
			for l in $(seq $mina $maxa); do
				ping $addra.$l.$j.$i -c1 -W1 &
			done
		done
	done | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//"

elif [[ $class -ge '128' ]] && [[ $class -lt '192' ]]; then
	echo "Classe B"
	addrb=$(echo $gateway | cut -d '.' -f 1,2)
	for i in $(seq $minc $maxc); do
		for j in $(seq $minb $maxb); do
			ping $addrb.$j.$i -c1 -W1 &
		done
	done | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//"

elif [[ $class -ge '192' ]] && [[ $class -lt '224' ]]; then
	echo "Classe C"
	addrc=$(echo $gateway | cut -d '.' -f 1,2,3)
	for i in $(seq $minc $maxc); do
		ping $addrc.$i -c1 -W1 &
	done | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//"
fi
}

function welcome(){
clear
initialize_colors
check_compatibility

}

function ping_sweep(){
welcome
	
if [[ -z $OPTION2 ]]; then
	echo_white "Enter IP: "
	read -rp "> " YIP

	min=$(ipcalc $YIP | grep HostMin | awk '{print $2}')
	max=$(ipcalc $YIP | grep HostMax | awk '{print $2}')
	addra=$(echo $YIP | cut -d '.' -f 1)
	ip_address
	for i in $(seq $minc $maxc); do
		for j in $(seq $minb $maxb); do
			for l in $(seq $mina $maxa); do
				ping $addra.$l.$j.$i -c1 -W1 &
			done
		done
	done | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//"
	else
	min=$(ipcalc $OPTION2 | grep HostMin | awk '{print $2}')
	max=$(ipcalc $OPTION2 | grep HostMax | awk '{print $2}')
	addra=$(echo $OPTION2 | cut -d '.' -f 1)
	ip_address
	for i in $(seq $minc $maxc); do
		for j in $(seq $minb $maxb); do
			for l in $(seq $mina $maxa); do
				ping $addra.$l.$j.$i -c1 -W1 &
			done
		done
	done | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//"
	fi

}

function aport(){
	welcome
	if [[ -z $OPTION2 ]]; then
		echo_white "Enter IP: "
		read -rp "> " YIP
		nmap -p0-65535 $YIP
	else
		nmap -p0-65535 $OPTION2
	fi
}

function auto_ping_sweep_port(){
	welcome
	auto_ip_address

	addra=$(echo $gateway | cut -d '.' -f 1)
	for i in $(seq $minc $maxc); do 
		for j in $(seq $minb $maxb); do 
			for l in $(seq $mina $maxa); do 
				test=$(ping $addra.$l.$j.$i -c1 -W1 | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//")
				if [[ $test = "$addra.$l.$j.$i" ]]; then
					echo_green "\n--------------------Starting Nmap Scan on host ${brown_color}$test${normal_color}${green_color}--------------------${normal_color}\n"
					nmap $addra.$l.$j.$i
				fi
			done 
		done 
	done 
	
}

	
function help()
{

	HELP_TEXT='
List of commands and options:
-------------------------------
./orion.sh auto_ping_sweep: Auto Ping sweep
./orion.sh ping_sweep {IP Address}: Manual Ping sweep
./orion.sh aport {IP Address}: Scanning all ports with nmap
./orion.sh auto_ping_sweep_port: Auto Ping sweep and simple nmap
'
echo "$HELP_TEXT"
}


case "$OPTION1" in

	auto_ping_sweep | aps) 				auto_ping_sweep ;;
	ping_sweep | ps) 					ping_sweep $OPTION2 ;;
	aport | ap)							aport $OPTION2;;
	auto_ping_sweep_port | apsp)		auto_ping_sweep_port ;;
	help | h)							help ;;
	*) 									help ;;
esac
