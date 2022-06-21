#!/bin/bash
cd /home/$USER
# Update
sudo apt update && sudo apt upgrade -y
# Install Dependencies First
sudo apt install dkms git build-essential libelf-dev linux-headers-$(uname -r) -y
# Clone the Repo
git clone https://github.com/aircrack-ng/rtl8812au.git
# Navigate into it
cd rtl8812au/
# Install
sudo make dkms_install
echo "Unplug and plug the device"
read -p "Press enter to continue"
sudo apt install aircrack-ng -y
sudo airmon-ng check kill
sudo apt purge aircrack-ng -y
sudo apt autoremove
sudo apt clean
sudo apt clean
# To Uninstall you can invoke "\sudo make dkms_remove\"
echo "To Uninstall you can invoke, \"sudo make dkms_remove\" in the terminal."
echo "Then delete the rtl8812au directory in your home folder."
echo ""
sudo dkms status
echo "Reboot if Network and Wifi disappear from Settings.."
