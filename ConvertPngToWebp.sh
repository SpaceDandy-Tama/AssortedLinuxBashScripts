#!/bin/bash

if apt-cache show webp; then
	echo Skipping webp installation
else
	sudo apt install webp -y
fi

for f in *.png; do cwebp -q 95 -mt $f -o $(basename $f .png).webp; done
