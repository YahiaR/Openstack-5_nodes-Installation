sudo apt -y install chrony
sudo sed -i 's/pool.*//g' /etc/chrony/chrony.conf
echo "server controller iburst" | sudo tee -a /etc/chrony/chrony.conf
sudo service chrony restart
apt-get -y update && apt-get -y dist-upgrade