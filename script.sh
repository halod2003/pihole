#!/bin/bash
#Pi-Hole Setup

## 1) Update Pi

#echo Updating Pi

#sudo apt update
#sudo apt upgrade

##Install Golang
##sudo apt-get install golang

#echo Update complete

## 2) Collecting information

echo What is the IP address of Pi-Hole?
exec < /dev/tty
read IPAddr
echo "Thank you for providing $IPAddr"
echo "    "

## 3) Create supporting direcoties and files

##For Pi-Hole

cd /home/pi
mkdir pihole
cd pihole
mkdir pihole
mkdir dnsmasq.d
cd /home/pi

#For Prometheus
mkdir prometheus
cd prometheus
curl -s https://raw.githubusercontent.com/halod2003/pihole/main/prometheus.yml -o prometheus.yml


## 4) Install services using docker-compose

PiExpoInfo='        - PIHOLE_HOSTNAME='

curl -s https://raw.githubusercontent.com/halod2003/pihole/main/docker-compose.yml -o docker-compose.yml
echo "$PiExpoInfo$IPAddr" >> docker-compose.yml

##Start containers using docker-compose files

sudo docker-compose -f docker-compose.yml up -d

## 5) Install Node Exporter

cd /home/pi
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-armv7.tar.gz
tar xfz node_exporter-1.1.2.linux-armv7.tar.gz
rm node_exporter-1.1.2.linux-armv7.tar.gz
mv node_exporter-1.1.2.linux-armv7/ node_exporter
curl -s https://raw.githubusercontent.com/halod2003/pihole/main/node_exporter.service -o node_exporter.service
sudo mv node_exporter.service /etc/systemd/system/
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

## 5) Print access information

echo Installation complete
echo "Access Information"
echo "------------------"
echo "Pi-hole http://$IPAddr"
echo "Grafana http://$IPAddr:3000"
echo "Portainer http://$IPAddr:9000"
echo "Prometheus http://$IPAddr:9090"
exit 1
