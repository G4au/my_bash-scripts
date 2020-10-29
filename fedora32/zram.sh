#!/bin/bash
if [[  $EUID -ne 0 ]]; then
echo "Bu Script Çalıştırmak için süperKullanıcı/superuser(root) olmanız gerekiyor"
exit 1
fi
echo "Zram"
touch /etc/modules-load.d/zram.conf
echo "zram" >> /etc/modules-load.d/zram.conf
touch /etc/modprobe.d/zram.conf
echo "options zram num_devices=1" >> /etc/modprobe.d/zram.conf
touch /etc/udev/rules.d/99-zram.rules
echo 'KERNEL=="zram0", ATTR{disksize}="7120M",TAG+="systemd"' >> /etc/udev/rules.d/99-zram.rules
touch /etc/systemd/system/zram.service
echo "[Unit]
Description=Swap with zram
After=multi-user.target
[Service]
Type=oneshot 
RemainAfterExit=true
ExecStartPre=/sbin/mkswap /dev/zram0
ExecStart=/sbin/swapon /dev/zram0
ExecStop=/sbin/swapoff /dev/zram0
[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/zram.service
sudo systemctl enable zram
echo "Finnish."
echo "#################################"
echo "##########################################################"
echo "###########################################################################"
##################################
#######################################################

##################################################################
