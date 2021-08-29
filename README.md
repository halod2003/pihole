# pihole
PiHole deployment test

Prerequisites
-------------
1)	Install Docker & Docker-compose

curl -sSL https://get.docker.com | sh

sudo usermod -aG docker pi
sudo systemctl enable docker

sudo apt-get install libffi-dev libssl-dev -qq > /dev/null
sudo apt install python3-dev -qq > /dev/null
sudo apt-get install -y python3 python3-pip -qq > /dev/null
sudo pip3 install docker-compose

2) Execute installation script

sudo curl -sL https://github.com/halod2003/pihole/raw/main/script.sh | sh
