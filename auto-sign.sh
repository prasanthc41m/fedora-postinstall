sudo dnf install kmodtool akmods mokutil openssl -y
sudo kmodgenca -a
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
printf "Reboot now and enroll with the password!!"
