#!/bin/bash
#Pi-Hole Setup

## 1) Update Pi

echo Updating Pi

#sudo apt update
#sudo apt upgrade

## Installing dependencies
sudo apt-get install libffi-dev libssl-dev -qq > /dev/null
sudo apt install python3-dev -qq > /dev/null
sudo apt-get install -y python3 python3-pip -qq > /dev/null

##Install Golang
##sudo apt-get install golang

echo Update complete

## 2) Collecting information

echo What is the IP address of Pi-Hole?
exec < /dev/tty
read IPAddr
echo Thank you $IPAddr

## 2) Install Docker (Ref: https://pimylifeup.com/raspberry-pi-docker/)

echo Installing Docker and Docker compose

sudo apt-get install docker-ce -qq > /dev/null
sudo usermod -aG docker pi
sudo systemctl enable docker

sudo pip3 install docker-compose --quiet

echo Docker and Docker compose Installed

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
curl https://raw.githubusercontent.com/halod2003/pihole/main/prometheus.yml -o prometheus.yml

## 4) Install services using docker-compose

PiExpoInfo='        - PIHOLE_HOSTNAME='

curl https://raw.githubusercontent.com/halod2003/pihole/main/docker-compose.yml -o docker-compose.yml
echo "$PiExpoInfo$IPAddr" >> docker-compose.yml

##Start containers using docker-compose files

sudo docker-compose -f docker-compose.yml up -d

echo Installation complete
echo "Access Information"
echo "------------------"
echo "Pi-hole http://$IPAddr"
echo "Grafana http://$IPAddr:3000"
echo "Portainer http://$IPAddr:9000"
echo "Prometheus http://$IPAddr:9090"
