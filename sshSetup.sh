#!/bin/bash

sudo apt install openssh-server openssh-client

# Generate a new key (press enter dont type anything)
ssh-keygen -t rsa

# Copy the key to a server machine
# ssh-copy-id -i <sshkey> <user>@<host>
ssh-copy-id -i ~/.ssh/id_rsa user@192.168.1.24
