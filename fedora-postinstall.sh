#!/bin/bash
printf "Run auto-sign.sh before this!!"
############################
## Grub
sudo dnf -y reinstall grub2-common
sudo grub2-editenv create
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo dracut -f --regenerate-all
## Terminal
cd /tmp
curl https://gist.githubusercontent.com/mage1k99/102108db3a65921d412bbf14f39e4c7d/raw/317d680e57483364cee1d09a0c603b3599967688/.bashrc -o .bashrc
mv ~/.bashrc ~/.bashrc-bak
mv /tmp/.bashrc ~/.bashrc
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
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="20:c1:9b:45:cc:8e", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="wlan*", NAME="wlan0"

# USB device Wlan Device
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:c0:ca:75:e2:d5", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="wlan*", NAME="wlan1"

# USB device lan Device
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="32:C5:F9:1E:55:2D", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="enp*", NAME="eth1"
'
EOL
sudo mv 70-persistent-net.rules /etc/udev/rules.d/70-persistent-net.rules	
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
https://extensions.gnome.org/extension/4687/server-status-indicator/
https://extensions.gnome.org/extension/4033/x11-gestures/
https://extensions.gnome.org/extension/6162/solaar-extension/
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
sudo dnf copr enable aleasto/waydroid
sudo dnf install -y htop nload speedtest-cli hwinfo.x86_64 hicolor-icon-theme.noarch lm_sensors.x86_64 bluez google-chrome-stable nmap solaar easyeffects.x86_64 qpwgraph.x86_64 radeontop lutris.x86_64 cloudflare-warp.x86_64 grsync pavucontrol.x86_64 waydroid perl-Image-ExifTool touchegg vlc vlc-extras cloudflare-warp clamav clamd clamav-update clamtk helvum.x86_64 @development-tools dkms VirtualBox.x86_64 dropbox.x86_64 onedrive.x86_64 snapd 
# You may also need to manually start the service
sleep 5
sudo systemctl start touchegg
sudo systemctl enable touchegg
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
sudo snap install bitwarden authy
#
sudo flatpak install -y com.mattjakeman.ExtensionManager org.gnome.Extensions fr.romainvigier.MetadataCleaner com.belmoussaoui.Obfuscate cc.arduino.IDE2 in.srev.guiscrcpy us.zoom.Zoom org.filezillaproject.Filezilla  io.freetubeapp.FreeTube nz.mega.MEGAsync org.tigervnc.vncviewer com.microsoft.Edge org.wireshark.Wireshark org.gnome.DejaDup com.spotify.Client org.raspberrypi.rpi-imager org.telegram.desktop com.github.eneshecan.WhatsAppForLinux com.github.ADBeveridge.Raider org.gnome.Builder
#
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap
sudo snap set system experimental.parallel-instances=true
sudo snap install authy bitwarden 
#
#############################
## pipewire
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
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update -y
sudo dnf install openssl xdg-utils ffmpeg -y
wget https://dn3.freedownloadmanager.org/6/latest/freedownloadmanager.deb
mkdir freedownloadmanager
cd freedownloadmanager
ar x ../freedownloadmanager.deb
sudo tar -xvJf data.tar.xz -C /
#############################
