#!/bin/bash
#Pi-Hole Setup

## 1) Update Pi

echo Updating Pi

#sudo apt update
#sudo apt upgrade

## Installing dependencies
sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip

##Install Golang
##sudo apt-get install golang

echo Update complete

## 2) Collecting information

echo What is the IP address of Pi-Hole?
read IPAddr
echo Thank you $IPAddr

## 2) Install Docker (Ref: https://pimylifeup.com/raspberry-pi-docker/)

echo Installing Docker & Docker compose

curl -sSL https://get.docker.com | sh

sudo usermod -aG docker pi
sudo pip3 install docker-compose
sudo systemctl enable docker

echo Docker Installed

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

curl https://github.com/halod2003/pihole/raw/main/docker-compose.yml -o docker-compose.yml
echo "$PiExpoInfo$IPAddr" >> docker-compose.yml

##Start containers using docker-compose files

sudo docker-compose -f docker-compose.yml up -d

echo Installation complete
echo Access Information
echo ------------------
echo Pi-hole http://<IP-Address>
echo Grafana http://<IP-Address>:3000
echo Portainer http://<IP-Address>:9000
echo Prometheus http://<IP-Address>:9090
