#!/bin/bash
echo "###################################################################"
echo "#                                                                 #"
echo "# This setup will install below services as part of the deployment#"
echo "#   1) Node-Exporter for Raspberry Pi system monitoring           #"
echo "#   2) Pi-Hole                                                    #"
echo "#   3) Prometheus                                                 #"
echo "#   4) Pi-Hole Exporter                                           #"
echo "#   5) Grafana (with 2 dashboards)                                #"
echo "#                                                                 #"
echo "###################################################################"

## 1) Update Pi

#echo Updating Pi

#sudo apt update
#sudo apt upgrade -y

##Install Golang
##sudo apt-get install golang

#echo Update complete

## 2) Collecting information

echo What is the IP address of Pi-Hole?
exec < /dev/tty
read IPAddr
echo "Thank you for providing $IPAddr"
echo "    "

## 3) Create supporting directories and files

cd /home/pi
mkdir -p {prometheus,pihole/{pihole,dnsmasq.d},grafana/provisioning/{datasources,dashboards},tmpinst}

#Download and modify configuration files
curl -s https://raw.githubusercontent.com/halod2003/pihole/main/prometheus.yml -o prometheus/prometheus.yml
curl -s https://raw.githubusercontent.com/halod2003/pihole/main/docker-compose.yml -o tmpinst/docker-compose.yml
curl -s https://raw.githubusercontent.com/halod2003/pihole/main/datasource.yml -o grafana/provisioning/datasources/datasource.yml
curl -sL https://raw.githubusercontent.com/halod2003/pihole/main/dashboard.yml  -o grafana/provisioning/dashboards/dashboard.yml
curl -sL https://grafana.com/api/dashboards/1860/revisions/23/download -o grafana/provisioning/dashboards/dash1.json
curl -sL https://grafana.com/api/dashboards/10176/revisions/2/download -o grafana/provisioning/dashboards/dash2.json
sudo sed -i "s/IP_Addr/$IPAddr/" prometheus/prometheus.yml
sudo sed -i "s/IP_Addr/$IPAddr/" tmpinst/docker-compose.yml
sudo sed -i "s/IP_Addr/$IPAddr/" grafana/provisioning/datasources/datasource.yml

## 4) Install Node Exporter

cd /home/pi
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-armv7.tar.gz
tar xfz node_exporter-1.1.2.linux-armv7.tar.gz
rm node_exporter-1.1.2.linux-armv7.tar.gz
mv node_exporter-1.1.2.linux-armv7/ node_exporter
curl -s https://raw.githubusercontent.com/halod2003/pihole/main/node_exporter.service -o tmpinst/node_exporter.service
sudo mv tmpinst/node_exporter.service /etc/systemd/system/
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

## 5) Install services using docker-compose

sudo docker-compose -f tmpinst/docker-compose.yml up -d

#clean-up
sudo rm tmpinst/docker-compose.yml
sudo rm -r tmpinst

## 6) Print access information

echo Installation complete
echo "    "
echo "Access Information"
echo "------------------"
echo "    "
echo "Pi-hole http://$IPAddr"
echo "Grafana http://$IPAddr:3000"
echo "Portainer http://$IPAddr:9000"
echo "Prometheus http://$IPAddr:9090"
echo "Press any key to continue"
while [ true ] ; do
read -t 15 -n 1
if [ $? = 0 ] ; then
exit ;
else
echo "waiting for the keypress"
fi
done
