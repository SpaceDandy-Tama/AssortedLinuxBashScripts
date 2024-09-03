#! /bin/bash

sudo apt purge gnome-2048 -y
sudo apt purge gnome-contacts -y
sudo apt purge gnome-calendar -y
sudo apt purge gnome-weather -y
sudo apt purge gnome-chess -y
sudo apt purge gnome-maps -y
sudo apt purge gnome-klotski -y
sudo apt purge gnome-mahjongg -y
sudo apt purge gnome-mines -y
sudo apt purge gnome-music -y
sudo apt purge gnome-nibbles -y
sudo apt purge gnome-robots -y
sudo apt purge gnome-sound-recorder -y
sudo apt purge gnome-sudoku -y
sudo apt purge gnome-taquin -y
sudo apt purge gnome-tetravex -y
sudo apt purge totem -y
sudo apt purge simple-scan -y
sudo apt purge evince -y
sudo apt purge seahorse -y
sudo apt purge aisleriot -y
sudo apt purge kasumi -y
sudo apt purge five-or-more -y
sudo apt purge four-in-a-row -y
sudo apt purge goldendict -y
sudo apt purge hitori -y
sudo apt purge cheese -y
sudo apt purge lightsoff -y
sudo apt purge mlterm* -y
sudo apt purge mozc* -y
sudo apt purge im-config* -y
sudo apt purge uim* -y
sudo apt purge quadrapassel -y
sudo apt purge rhythmbox -y
sudo apt purge iagno -y
sudo apt purge shotwell -y
sudo apt purge swell-foop -y
sudo apt purge tali -y
sudo apt purge xiterm+thai -y
sudo apt purge thunderbird -y
sudo apt purge evolution* -y

#Stupid Hebrew Calendar
sudo rm /usr/bin/ghcal
sudo rm /usr/bin/ghcal-he
sudo rm /usr/share/applications/ghcal.desktop

sudo apt update
sudo apt upgrade -y

sudo apt install audacious -y
sudo apt install vlc -y
sudo apt install okular -y
sudo apt install htop -y
sudo apt install neofetch -y
sudo apt install hardinfo -y
sudo apt install glmark2 -y
sudo apt install krita -y
sudo apt install inkscape -y
sudo apt install kdenlive -y
sudo apt install obs-studio -y
sudo apt install gamemode -y
sudo apt install bash-completion -y
sudo apt install gnome-shell -y
sudo apt install gnome-shell-extension-appindicator -y
sudo apt install gnome-shell-extension-desktop-icons-ng -y
sudo apt install gnome-shell-extension-gamemode -y
sudo apt install wget -y

wget https://repo.steampowered.com/steam/archive/stable/steam.gpg
sudo mv steam.gpg /usr/share/keyrings/steam.gpg
sudo tee /etc/apt/sources.list.d/steam-stable.list <<'EOF'
deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam
deb-src [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam
EOF

sudo dpkg --add-architecture i386
sudo apt update
sudo apt-get install libgl1-mesa-dri:amd64 libgl1-mesa-dri:i386 libgl1-mesa-glx:amd64 libgl1-mesa-glx:i386 steam-launcher -y

sudo apt install git -y
sudo apt install git-lfs -y
git-lfs install

sudo apt purge kdeconnect -y
sudo apt purge systemsettings -y

sudo apt autoremove -y
sudo apt clean

sudo apt install flatpak -y
sudo apt install gnome-software-plugin-flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub io.missioncenter.MissionCenter -y
flatpak install flathub com.discordapp.Discord -y

sudo apt purge gnome-session -y
sudo apt install gnome-session -y

#rabbitvcs-nautilus is missing in bookworm apt repos
#sudo apt install rabbitvcs-core rabbitvcs-nautilus -y
#sudo apt install rabbitvcs-gedit rabbitvcs-cli #Optional

sudo reboot
