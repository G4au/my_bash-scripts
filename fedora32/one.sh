#!/bin/bash
if [[  $EUID -ne 0 ]]; then
echo "Bu Script Çalıştırmak için süperKullanıcı/superuser(root) olmanız gerekiyor"
exit 1
fi
sudo update -y
##################################################################
sudo dnf install -y kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
##################################################################
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
echo "ZRAM bitti"
echo "#################################"
echo "##########################################################"
echo "###########################################################################"
##################################
#######################################################

##################################################################

sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
##################################################################
 #32 Bit
sudo dnf install -y xorg-x11-drv-nvidia-340xx-libs.i686 xorg-x11-drv-nvidia-340xx-cuda.i686 xorg-x11-drv-nvidia-340xx-devel.i686
#64 Bit
sudo dnf install -y xorg-x11-drv-nvidia-340xx-libs.x86_64 xorg-x11-drv-nvidia-340xx-cuda.x86_64 xorg-x11-drv-nvidia-340xx-devel.x86_64 xorg-x11-drv-nvidia-340xx-kmodsrc.x86_64 kmod-nvidia-340xx.x86_64 xorg-x11-drv-nvidia-340xx.x86_64
#Ekstra Paketler
sudo dnf install -y mesa-libglapi freeglut-devel
#wifi
sudo dnf install broadcom-wl akmod-wl
