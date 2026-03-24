rm /etc/systemd/network/99-default.link
rm /etc/systemd/network/89-unmanage.network
rm /etc/systemd/system/multi-user.target.wants/connman.service
重命名网口名字
/etc/systemd/network/10-eth.link

systemctl restart systemd-networkd