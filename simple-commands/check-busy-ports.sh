sudo lsof -i:22

sudo lsof -i -P -n

netstat -tulpn | grep LISTEN

netstat -tulpn | grep ':443' 
# netsh -tulpn 80