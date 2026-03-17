sudo systemctl stop NetworkManager
sudo rm /var/lib/NetworkManager/NetworkManager.state
sudo systemctl start NetworkManager