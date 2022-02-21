#!/bin/bash
if [ "$1" == "" ]
then
echo "Example: ./pingsweep.sh 192.168.1"
else
for ip in `seq 1 254`; do
	ping -c 1 $1.$ip | grep "64 bytes" | cut -d " " -f 4 | sed "s/.$//" &
done
fi

#Pour faire un Nmap de la list
#./nomdufichier.sh 192.168.1 > list.txt
#for ip in $(ccat list.txt); do nmap -Pn $ip; done