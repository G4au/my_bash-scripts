#!/bin/bash
if [[  $EUID -ne 0 ]]; then
echo "You need to be superuser / superuser (root) to run this script"
exit 1
fi

sudo dnf update -y
##################################################################
sudo dnf install -y anydesk redshift plasma-applet-redshift-control onboard telegram-desktop Discord-installer brave-browser hwinfo htop ffmpeg plasma-discover-snap plasma-discover-flatpak pinta zsh git curl redhat-lsb-core
#
##################################################################
sudo dnf install -y kvantum snapd flatpak
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install snapd
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
##################################################################
sudo dnf install -y swift-lang afpfs-ng.x86_64 apfs-fuse.x86_64 shairplay.x86_64
##################################################################
sudo dnf install -y mono-devel dotnet-sdk-3.1 qt-creator.i686 qt-creator.x86_64  filezilla nodejs
sudo snap install code --classic
##################################################################
sudo dnf group install -y --with-optional --skip-broken "c-development" "development-libs" "development-tools"
sudo dnf group install -y --with-optional --skip-broken "rpm-development-tools" "php" "java-development" "java"
##################################################################
sudo dnf install -y fedora-workstation-repositories
sudo dnf install -y steam --enablerepo=rpmfusion-nonfree-steam
sudo dnf install -y lutris minetest obs-studio
sudo dnf group install -y --with-optional "libreoffice" "office"

sudo dnf group install --with-optional "security-lab"
