# Ping-Sweep
Script court pour effectuer un balayage ping de votre sous-réseau actuel

`./pings_sweeps.sh 192.168.1` ou alors mettre le résultat dans un fichier txt `./pings_sweeps.sh 192.168.1 > iplist.txt`

Possiblité de passer la list sous nmap avec la commande:

`for ip in $(ccat iplist.txt); do nmap -Pn $ip; done`
