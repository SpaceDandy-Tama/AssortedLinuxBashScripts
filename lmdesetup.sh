#! /bin/bash

sudo apt purge mintupdate -y
sudo apt purge warpinator -y
sudo apt purge xreader -y
sudo apt purge seahorse -y
sudo apt purge redshift -y
sudo apt purge bulky -y
sudo apt purge sticky -y
sudo apt purge drawing -y
sudo apt purge pix -y
sudo apt purge webapp-manager -y
sudo apt purge hexchat -y
sudo apt purge thunderbird -y
sudo apt purge celluloid -y
sudo apt purge rhythmbox -y
sudo apt purge timeshift -y

sudo apt update
sudo apt upgrade -y

sudo apt install audacious -y
sudo apt install vlc -y
sudo apt install okular -y
sudo apt install htop -y
sudo apt install neofetch -y
sudo apt install hardinfo -y
sudo apt install glmark2 -y
sudo apt install steam -y
sudo apt install krita -y
sudo apt install inkscape -y
sudo apt install kdenlive -y
sudo apt install obs-studio -y

sudo apt purge kdeconnect -y

sudo apt autoremove -y
sudo apt clean

flatpak install flathub io.missioncenter.MissionCenter -y
flatpak install flathub com.discordapp.Discord -y
