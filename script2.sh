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

sudo curl -sSL https://get.docker.com | sh

sudo usermod -aG docker pi
sudo pip3 install docker-compose --quiet
sudo systemctl enable docker

echo Docker Installed
