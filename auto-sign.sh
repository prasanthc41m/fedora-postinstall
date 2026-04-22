#!/bin/bash
############################
# Check autosign installation status.
output=$(sudo mokutil --import /etc/pki/akmods/certs/public_key.der)

# Check if the output contains the word "already enrolled"
if [[ $output == *"already enrolled"* ]]; then
    # If "already enrolled" is found, proceed with the first script
    echo "Secure boot key enrolled. Proceeding with signing"
    # Add your code for Script 1 here
    sudo mokutil --list-enrolled
    sudo dracut -f --regenerate-all
    sudo akmods --force
    sudo dracut --force
else
    # If "already enrolled" is not found, prompt the user to run a different script
    echo "Secure boot key not enrolled'."
    echo "Please run autosign"
    # sudo mokutil --reset
    # Optionally, you can provide Script 2
sudo dnf install kmodtool akmods mokutil dkms openssl -y
sudo kmodgenca -a
sudo dkms generate_mok
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
sudo mokutil --import /var/lib/dkms/mok.pub
printf "Reboot now and enroll with the password!!"
fi
#
#Signing key: /etc/pki/akmods/private/secureboot.key
#Public certificate (MOK): /etc/pki/akmods/certs/secureboot.crt
