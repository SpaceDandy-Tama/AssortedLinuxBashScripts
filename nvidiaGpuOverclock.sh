#!/bin/bash

# Tested in Popos.22.04

echo 'Make sure you have a working Nvidia GPU and Drivers'
echo 'You will make the necessary x11 config changes manually guided by this script.'
echo 'So that if your X explodes you will know the exact changes that borked it.'
read -p "Press enter to continue..."
echo 'If X blows, hold down Shift key if CSM, or if UEFI tap ESC key continuously during boot to access grub menu.'
echo 'And from there, revert your changes. If you do not know how, maybe terminate this script now.'
echo 'Good luck!'
read -p "Press enter to continue..."

# Make sure xdg-open is installed. It's required by this script.
sudo apt install xdg-utils -y

# Nvidia X11 Stuff
sudo nvidia-xconfig -a
echo 'Add the following to "Device" Section in /etc/X11/xorg.conf'
echo 'Option "AllowEmptyInitialConfiguration" "True"'
echo 'Option "Coolbits" "28"'
sudo xdg-open /etc/X11/xorg.conf
read -p "Press enter to continue..."
echo 'Add the following to /etc/X11/Xwrapper.config'
echo 'allowed_users = anybody'
sudo xdg-open /etc/X11/Xwrapper.config
read -p "Press enter to continue..."

# Create GPU overclock start stop scripts
Dir="/home/$USER/bin"
[ -d "$Dir" ] || mkdir "$Dir"
File="$Dir/start_gpuGameMode.sh"
echo '#!/bin/bash' > $File
echo "" >> $File
echo "# 0 = Adaptive, 1 = Prefer Maximum Performance, 2 = Auto" >> $File
echo "# nvidia-settings -a '[gpu:0]/GpuPowerMizerMode=2'" >> $File
echo "# Remove '#' to use these. The value 1 in brackes is the 'Level' value in nvidia x server setting panels PowerMizer Options." >> $File
echo "# nvidia-settings -a '[gpu:0]/GPUGraphicsClockOffset[1]=0'" >> $File
echo "# nvidia-settings -a '[gpu:0]/GPUMemoryTransferRateOffset[1]=0'" >> $File
echo "# nvidia-settings -a '[gpu:0]/GPUOverVoltageOffset[1]=0'" >> $File
echo "" >> $File
echo "# You can increase/decrease monitor refresh rate and resolution if power/battery consumption is a priority."
echo '# xrandr --output DP-4 --mode "insert res" --rate 60' >> $File
sudo chmod +x $File
cp "$Dir/start_gpuGameMode.sh" "$Dir/stop_gpuGameMode.sh"
echo "$Dir/start_gpuGameMode.sh and $Dir/stop_gpuGameMode.sh created."

# Gamemode Integration
if apt-cache show gamemode; then
	#Installing Gamemode
	sudo apt update
	sudo apt upgrade -y
	sudo apt install gamemode -y # https://github.com/FeralInteractive/gamemode
	
	# Install the gnome extension to gamemode
	echo '(Optional)Install gamemode gnome extension using the browser from this link:'
	echo 'https://extensions.gnome.org/extension/1852/gamemode/'
	echo 'Right click and choose "Open Link", or copy the link and paste into your browser.'
	# xdg-open https://extensions.gnome.org/extension/1852/gamemode/ #using xdg-open for internet addres seems to cause a bug
	read -p "Press enter to continue..."

	# Gamemode integration of start stop scripts
	sudo cp /usr/share/gamemode/gamemode.ini /usr/share/gamemode/gamemode.ini.backup
	sudo echo "" >> /usr/share/gamemode/gamemode.ini
	sudo echo 'start=notify-send "GameMode started"' >> /usr/share/gamemode/gamemode.ini
	sudo echo '    /home/$USER/bin/start_gpuGameMode.sh' >> /usr/share/gamemode/gamemode.ini
	sudo echo "" >> /usr/share/gamemode/gamemode.ini
	sudo echo 'end=notify-send "GameMode ended"' >> /usr/share/gamemode/gamemode.ini
	sudo echo '    /home/$USER/bin/stop_gpuGameMode.sh' >> /usr/share/gamemode/gamemode.ini
	echo "Scripts integrated to GameMode."
else
	echo "gamemode not available in apt repo. Gamemode integration cannot be done."
fi


