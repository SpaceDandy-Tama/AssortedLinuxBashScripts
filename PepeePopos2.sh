#!/bin/bash

cd /home/$USER

# Let's create some useful templates
Dir="/home/$USER/Templates"
[ -d "$Dir" ] || mkdir "$Dir"
touch "$Dir/Text File.txt"
echo '#!/bin/bash' > "$Dir/Bash Script.sh"
sudo chmod +x "$Dir/Bash Script.sh"

# Show Hidden Files and Folders (Not just for nautilus)
dumpFile="gsettings.dump"
gsettings list-recursively | grep show-hidden > "$dumpFile"
while IFS= read -r line
do
	lineArray=($line)
	gsettings set ${lineArray[0]} ${lineArray[1]} true
done < "$dumpFile"
rm "$dumpFile"

#Disable Stupid Shit like tty console bullshit
	#nautilus
dumpFile="gsettings.dump"
gsettings list-recursively | grep switch-to-session > "$dumpFile"
while IFS= read -r line
do
	lineArray=($line)
	gsettings set ${lineArray[0]} ${lineArray[1]} "['']"
done < "$dumpFile"
rm "$dumpFile"
	#x11
echo "" >> /etc/X11/xorg.conf
echo "Section \"ServerFlags\"" >> /etc/X11/xorg.conf
echo "    Option \"DontVTSwitch\" \"true\"" >> /etc/X11/xorg.conf
echo "EndSection" >> /etc/X11/xorg.conf

# Check for updates
sudo apt update
# Download and apply upgrades
sudo apt upgrade -y

# Install the Best and Most Useful Applications
declare -a Packages=()
Packages[0]=htop # Tops top
Packages[1]=lm-sensors # Shows temps
Packages[2]=glmark2 # OpenGL Benchmark https://github.com/glmark2/glmark2
Packages[3]=vkmark # Vulkan Benchmark https://github.com/vkmark/vkmark
Packages[4]=gstreamer1.0-libav # AAC decoder plugin https://gitlab.freedesktop.org/gstreamer/gstreamer
Packages[5]=gstreamer1.0-plugins-good # H.265 decoder plugin https://gitlab.freedesktop.org/gstreamer/gstreamer
Packages[6]=ffmpeg # H.264 decoder plugin https://git.ffmpeg.org/ffmpeg.git
Packages[7]=7zip # 7zz https://www.7-zip.org/
Packages[8]=notepadqq #Notepad++ Analogue https://github.com/notepadqq/notepadqq
Packages[9]=audacious # Audio Player https://github.com/audacious-media-player/audacious
Packages[10]=vlc # Video Player https://github.com/videolan/vlc
Packages[11]=okular # PDF reader (has background color change support)
Packages[12]=steam # Steam https://store.steampowered.com/
Packages[13]=transmission # Torrent Client
Packages[14]=gamemode # CPU Governor https://github.com/FeralInteractive/gamemode
Packages[15]=git #git
Packages[16]=git-lfs #git large file thingy
Packages[17]=rabbitvcs-nautilus # Nautilus Git integration thingy
Packages[18]=krita #Photoshop alternative
Packages[19]=inkscape #Illustrator alternative
Packages[20]=kdenlive #Video Editor
Packages[21]=obs-studio #Screen Recorder

for i in "${Packages[@]}"
do
	if apt-cache show $i; then
		sudo apt install $i -y
	else
		echo "Skipping $i installation..."
	fi
done

#Initialize git-lfs
git lfs install

# Need the gnome extension to gamemode as well
echo 'Install gamemode gnome extension using the browser from this link: (or skip)'
echo 'https://extensions.gnome.org/extension/1852/gamemode/'
echo 'Right click and choose "Open Link", or copy the link and paste into your browser.'
# xdg-open https://extensions.gnome.org/extension/1852/gamemode/ #using xdg-open for internet address seems to cause a bug
read -p "Press enter to continue..."

# Spotify
if apt-cache show curl; then
	sudo apt install curl -y
	curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt update
	sudo apt install spotify-client -y
fi

# Webp support to Image Viewer
sudo add-apt-repository ppa:helkaluin/webp-pixbuf-loader
sudo apt update
sudo apt install webp-pixbuf-loader

# Cleanup
sudo apt autoremove -y
sudo apt clean
