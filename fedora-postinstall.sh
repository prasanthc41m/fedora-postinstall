#!/bin/bash
############################
# Check autosign installation status.
output=$(sudo mokutil --import /etc/pki/akmods/certs/public_key.der)

# Check if the output contains the word "already enrolled"
if [[ $output == *"already enrolled"* ]]; then
    # If "already enrolled" is found, proceed with the first script
    echo "Secure boot key enrolled. Proceeding with fedora-postinstall.sh"
    # Add your code for Script 1 here
else
    # If "already enrolled" is not found, prompt the user to run a different script
    echo "Secure boot key not enrolled'."
    echo "Please run autosign"
    # Optionally, you can provide Script 2
sudo dnf install kmodtool akmods mokutil openssl -y
sudo kmodgenca -a
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
sudo mokutil --import /var/lib/dkms/mok.pub"
printf "Reboot now and enroll with the password!!"
fi
#
############################
## Grub
sudo dnf -y reinstall grub2-common
sudo grub2-editenv create
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo dracut -f --regenerate-all
## Terminal
cd /tmp
git clone https://github.com/prasanthc41m/fedora-postinstall.git
mv ~/.bashrc ~/.bashrc-bak
cp fedora-postinstall/bashrc ~/.bashrc
sudo cp /tmp/fedora-postinstall/bashrc /root/.bashrc
#############################
## Time 12h
gsettings set org.gnome.desktop.interface clock-format '12h' 
############################
## Nvidia
sudo dnf update -y
sudo dnf install -y make gcc kernel-headers kernel-devel akmod-nvidia-470xx.x86_64 xorg-x11-drv-nvidia-470xx.x86_64 xorg-x11-drv-nvidia-470xx-cuda.x86_64 nvidia-settings-470xx.x86_64
sudo akmods --force
sudo dracut --force
############################
## Grub2 Theme
cd /tmp/
git clone https://github.com/prasanthc41m/legion-grub.git
cd legion-grub
sudo bash install.sh
#############################
## Wallpaper
cd /tmp/
git clone https://github.com/prasanthc41m/legion-wallpaper.git
cd legion-wallpaper
sudo make install
#############################
## Mouse Icon
sudo dnf install -y gnome-tweaks inkscape xcursorgen
cd /tmp/
git clone https://github.com/prasanthc41m/legion-icons.git 
cd legion-icons
sudo make install
#############################
## Folder Icon
sudo dnf install papirus-icon-theme -y
sleep 5
gsettings set  org.gnome.desktop.interface icon-theme Papirus
#############################
## Network Interface Old Names
cd /tmp/
touch 70-persistent-net.rules
cat > 70-persistent-net.rules <<EOL
# This file was automatically generated by the /lib/udev/write_net_rules
# program, run by the persistent-net-generator.rules rules file.
#
# You can modify it, as long as you keep each rule on a single
# line, and change only the value of the NAME= key.

# PCI device lan Device
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="88:a4:c2:b7:96:b9", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eno*", NAME="eth0"

# PCI device Wlan Device
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="20:c1:9b:45:cc:8e", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="wl*", NAME="wlan0"

# USB device Wlan Device
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:c0:ca:75:e2:d5", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="wl*", NAME="wlan1"

# USB device lan Device
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="32:C5:F9:1E:55:2D", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="enp*", NAME="eth1"
'
EOL
sudo mv 70-persistent-net.rules /etc/udev/rules.d/70-persistent-net.rules	
sudo ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
###########################
## Conky
cd /tmp && sudo rm -rf conky* && git clone https://github.com/prasanthc41m/conky.git && cd conky && sudo bash conky-install.sh
###############################
## Conky-notes
sudo dnf install -y conky fontawesome-fonts.noarch fontawesome5-brands-fonts.noarch # Fedora
cd /tmp
git clone https://github.com/prasanthc41m/conky-sticky-notes.git
cd conky-sticky-notes 
sudo mv conky-notes.conf /etc/conky/
sudo mv conky-notes-startup.sh /etc/conky/
mkdir ~/.config/autostart
mv conky-notes.desktop ~/.config/autostart/
sudo cp ~/.config/autostart/conky-notes.desktop /usr/share/applications/conky-notes.desktop
sudo chmod +x /etc/conky/conky-notes-startup.sh
touch ~/Documents/conky-notes.txt
conky -c /etc/conky/conky-notes.conf -d
#############################
## Gnome Extensions
sudo dnf install -y gnome-extensions-app  
#
array=( 
https://extensions.gnome.org/extension/307/dash-to-dock/
https://extensions.gnome.org/extension/6145/switch-x11-wayland-default-session/
https://extensions.gnome.org/extension/19/user-themes/
https://extensions.gnome.org/extension/1852/gamemode/
https://extensions.gnome.org/extension/3193/blur-my-shell/
https://extensions.gnome.org/extension/7/removable-drive-menu/
https://extensions.gnome.org/extension/19/user-themes/
https://extensions.gnome.org/extension/16/auto-move-windows/
https://extensions.gnome.org/extension/615/appindicator-support/
https://extensions.gnome.org/extension/5733/one-click-bios/
https://extensions.gnome.org/extension/4451/logo-menu/
https://extensions.gnome.org/extension/5353/window-state-manager/
https://extensions.gnome.org/extension/3724/net-speed-simplified/
https://extensions.gnome.org/extension/4470/media-controls/
https://extensions.gnome.org/extension/5260/ideapad-controls/
https://extensions.gnome.org/extension/4158/gnome-40-ui-improvements/
https://extensions.gnome.org/extension/4269/alphabetical-app-grid/
https://extensions.gnome.org/extension/3928/auto-select-headset/
https://extensions.gnome.org/extension/3991/bluetooth-battery/
https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/
https://extensions.gnome.org/extension/4670/cloudflare-1111-warp-switcher/
https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/
https://extensions.gnome.org/extension/5985/do-not-disturb-while-screen-sharing-or-recording/
https://extensions.gnome.org/extension/4907/easyeffects-preset-selector/
https://extensions.gnome.org/extension/4485/favourites-in-appgrid/
https://extensions.gnome.org/extension/4033/x11-gestures/
https://extensions.gnome.org/extension/6162/solaar-extension/
https://extensions.gnome.org/extension/6260/ping/
https://extensions.gnome.org/extension/4099/no-overview/
	)

for i in "${array[@]}"
do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
done
#############################
## Applications
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
curl -fsSl https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo | sudo tee /etc/yum.repos.d/cloudflare-warp.repo
sudo wget -O /etc/yum.repos.d/microsoft-prod.repo https://packages.microsoft.com/yumrepos/edge/config.repo
sudo dnf copr enable aleasto/waydroid
sudo echo "[dropbox-yum]
name=Dropbox Repository
baseurl=https://linux.dropbox.com/fedora/\$releasever/
gpgkey=https://linux.dropbox.com/fedora/rpm-public-key.asc" > /tmp/dropbox.repo
sudo cp /tmp/dropbox.repo /etc/yum.repos.d/
sudo dnf update -y
#
sudo dnf install -y htop nload speedtest-cli hwinfo.x86_64 hicolor-icon-theme.noarch lm_sensors.x86_64 bluez google-chrome-stable nmap solaar easyeffects.x86_64 qpwgraph.x86_64 radeontop lutris.x86_64 cloudflare-warp.x86_64 grsync luckybackup.x86_64 pavucontrol.x86_64 microsoft-edge-stable.x86_64 waydroid perl-Image-ExifTool touchegg vlc vlc-extras clamav clamd clamav-update clamtk helvum.x86_64 @development-tools dkms VirtualBox.x86_64 nautilus-dropbox onedrive.x86_64 wireshark.x86_64 filezilla.x86_64 snapd 
## Youtube issue fix
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video
# You may also need to manually start the service
sleep 5
sudo systemctl start touchegg
sudo systemctl enable touchegg
#
## add user to group
sudo usermod -a -G wireshark $USER
sudo usermod -a -G vboxusers $USER
#
ln -s /mnt/Data/OS/VBoxGuestAdditions_7.0.8.iso .config/VirtualBox/
#
# Fix bluetooth battery status issue in pipewire
cd /tmp/
sudo mkdir -p /etc/systemd/system/bluetooth.service.d/ 
cat > override.conf <<EOL
[Service]
ExecStart=
ExecStart=/usr/libexec/bluetooth/bluetoothd --experimental
EOL
sudo mv override.conf /etc/systemd/system/bluetooth.service.d/override.conf
sudo systemctl restart bluetooth.service
systemctl daemon-reload
sudo systemctl edit bluetooth.service
#
warp-cli register
systemctl --user disable warp-taskbar
systemctl --user stop warp-taskbar
systemctl --user mask warp-taskbar
#
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl enable clamav-freshclam --now
#
sudo snap install bitwarden 
sudo snap install authy
#
flatpak install -y com.mattjakeman.ExtensionManager fr.romainvigier.MetadataCleaner com.belmoussaoui.Obfuscate cc.arduino.IDE2 us.zoom.Zoom io.freetubeapp.FreeTube nz.mega.MEGAsync org.tigervnc.vncviewer org.gnome.DejaDup com.spotify.Client org.raspberrypi.rpi-imager com.github.eneshecan.WhatsAppForLinux com.github.ADBeveridge.Raider org.gnome.Builder
#
#############################
## Pipewire
easyeffects -q
cd /tmp
git clone https://github.com/prasanthc41m/EasyEffects-Presets.git
cd EasyEffects-Presets
cp *.json ~/.config/easyeffects/output/
#
cd /tmp
git clone https://github.com/prasanthc41m/EasyEffects-Presets-2.git
cd EasyEffects-Presets-2
cp LoudnessEqualizer.json ~/.config/easyeffects/output/
#
cd /tmp
git clone https://github.com/prasanthc41m/pipewire.git
sudo cp pipewire/bt-audio.desktop /usr/share/applications/
sudo cp -r pipewire /opt/
#############################
## DEB Applications
cd /tmp
sudo dnf update -y
sudo dnf install openssl xdg-utils ffmpeg -y
curl https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb -o freedownloadmanager.deb
mkdir -p freedownloadmanager
cd freedownloadmanager
ar x ../freedownloadmanager.deb
sudo tar -xvJf data.tar.xz -C /
#
#############################
## Web WhatsApp Linux Application
cd /tmp/
rm -rf /tmp/whatsapp-linux-build-dir
mkdir -p whatsapp-linux-build-dir
cd whatsapp-linux-build-dir
curl -o icon.png https://iconduck.com/api/v2/vectors/vctrmbe0zx1p/media/png/256/download
#wget https://iconduck.com/api/v2/vectors/vctrmbe0zx1p/media/png/256/download -O icon.png
# convert -resize 256x256^ icon.png icon.png
sudo dnf install npm -y
sudo npm install -g nativefier

nativefier -p linux -a x64 -i icon.png --disable-context-menu --disable-dev-tools --single-instance https://web.whatsapp.com/

sudo mv WhatsAppWeb-linux-x64 whatsapp
sudo rm -rf /opt/whatsapp
sudo mv /tmp/whatsapp-linux-build-dir/whatsapp /opt
sudo mv /opt/whatsapp/WhatsAppWeb  /opt/whatsapp/whatsapp
sudo chmod 755 -R /opt/whatsapp/

echo -e "[Desktop Entry]\nType=Application\nExec=/opt/whatsapp/whatsapp %F\nName=WhatsApp\nIcon=/opt/whatsapp/resources/app/icon.png\nCategories=Network;InstantMessaging;\nTerminal=false\nStartupNotify=true" > /tmp/whatsapp.desktop
sudo mv /tmp/whatsapp.desktop /usr/share/applications/
#
## Lenovo Legion Linux Support
cd /tmp/
git clone https://github.com/johnfanv2/LenovoLegionLinux.git
cd LenovoLegionLinux/kernel_module
sudo cp ./kernel_module/* /usr/src/LenovoLegionLinux-1.0.0 -r
sudo dkms add -m LenovoLegionLinux -v 1.0.0
sudo dkms build -m LenovoLegionLinux -v 1.0.0
#############################
echo "Installation success, reboot.."
#############################
