if [[  $EUID -ne 0 ]]; then
echo "Bu Script Çalıştırmak için superuser(root) olmanız gerekiyor"
exit 1
fi
function zramremove {
sudo systemctl stop swap-create@zram0
sudo dnf remove -y zram-generator-defaults
}

function zrammanueladd {

touch /etc/modules-load.d/zram.conf
echo "zram" > /etc/modules-load.d/zram.conf
touch /etc/modprobe.d/zram.conf
echo "options zram num_devices=1" > /etc/modprobe.d/zram.conf
touch /etc/udev/rules.d/99-zram.rules
echo 'KERNEL=="zram0", ATTR{disksize}="9120M",TAG+="systemd"' >> /etc/udev/rules.d/99-zram.rules
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
WantedBy=multi-user.target" > /etc/systemd/system/zram.service
sudo systemctl enable zram
}

function nvidia_340xx {
sudo dnf update -y
sudo dnf install -y kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm fedora-workstation-repositories
sudo dnf install -y --skip-broken xorg-x11-drv-nvidia-340xx-libs.i686 xorg-x11-drv-nvidia-340xx-cuda.i686 xorg-x11-drv-nvidia-340xx-devel.i686 xorg-x11-drv-nvidia-340xx-libs.x86_64 xorg-x11-drv-nvidia-340xx-cuda.x86_64 xorg-x11-drv-nvidia-340xx-devel.x86_64 xorg-x11-drv-nvidia-340xx-kmodsrc.x86_64 kmod-nvidia-340xx.x86_64 xorg-x11-drv-nvidia-340xx.x86_64 mesa-libglapi freeglut-devel
}

function repos {
cat > /etc/yum.repos.d/AnyDesk-Fedora.repo << "EOF" 
[anydesk]
name=AnyDesk Fedora - stable
baseurl=http://rpm.anydesk.com/fedora/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
##################################################################
rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
su -c 'curl https://download.mono-project.com/repo/centos8-stable.repo | tee /etc/yum.repos.d/mono-centos8-stable.repo'
##################################################################
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
##################################################################
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
##################################################################
sudo rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo
##################################################################
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

}

function dnfs {
cd rpms/
sudo dnf install -y --skip-broken ./*.rpm
cd ..
}

function runs {
cd runs/
find . -iname '*.run' -exec chmod +x ./"{}" \;
find . -iname '*.run' -exec ./"{}" \;
cd ..
}

function package1 {
sudo dnf install -y --skip-broken anydesk redshift plasma-applet-redshift-control onboard telegram-desktop discord brave-browser hwinfo htop ffmpeg plasma-discover-snap plasma-discover-flatpak pinta zsh git curl redhat-lsb-core
}

function snapandflatpaksettings {
sudo dnf install -y --skip-broken kvantum snapd flatpak
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install snapd
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
function programlang {
sudo dnf install -y --skip-broken swift-lang mono-devel dotnet-sdk-3.1
}

function webdev {
sudo dnf install -y --skip-broken qt-creator.i686 qt-creator.x86_64 filezilla nodejs codium sublime-text
sudo dnf group install -y --with-optional --skip-broken "c-development" "development-libs" "development-tools" "php"
sudo dnf group install -y --with-optional --skip-broken "rpm-development-tools" "java-development" "java"
}

function game {
sudo dnf install -y --skip-broken fedora-workstation-repositories
sudo dnf install -y --skip-broken steam --enablerepo=rpmfusion-nonfree-steam
sudo dnf install -y --skip-broken lutris minetest obs-studio
}

function libreoffice {
sudo dnf group install -y --with-optional --skip-broken "libreoffice"
}

function office {
sudo dnf group install -y --with-optional --skip-broken "office"
}

function security {
sudo dnf group install -y --with-optional --skip-broken "security-lab"
}

function themes {
cd ..
pwd
cd themes/We10XOS-kde-master
pwd
chmod +x ./install.sh
./install.sh
cd sddm/
pwd
chmod +x ./install.sh
sudo ./install.sh
cd ..
cd ..
pwd
cd themes/Harmony-kde-master
pwd
chmod +x ./install.sh
./install.sh
}

function config_My_Beta {
###
echo "Otomatik"
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
"""
echo "
GRUB_TIMEOUT=7
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rhgb quiet rd.driver.blacklist=nouveau"
GRUB_DISABLE_RECOVERY="false"
GRUB_ENABLE_BLSCFG=true
GRUB_GFXPAYLOAD_LINUX=text
" > /etc/sysconfig/grub"""
grub2-mkconfig -o /boot/grub2/grub.cfg && dnf remove -y xorg-x11-drv-nouveau && mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img && dracut /boot/initramfs-$(uname -r).img $(uname -r)
alias grafikmod="sudo systemctl set-default graphical.target"
alias umod="sudo systemctl set-default multi-user.target"
umod
grafikmod
umod
}

#zramremove
#zrammanueladd
#nvidia_340xx
repos
dnfs
package1
snapandflatpaksettings
libreoffice
#office
programlang
webdev
game
runs
#themes
