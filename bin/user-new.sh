#!/bin/bash

echo "Username:"
read USERNAME
echo "Password:"
read -s PASSWORD

echo -e "${PASSWORD}\n${PASSWORD}\nY\n" | adduser --disabled-login --shell /bin/false --gid 100 --gecos "" "${USERNAME}"
echo -e "${PASSWORD}\n${PASSWORD}\n" | smbpasswd -a "${USERNAME}"

usermod -aG users "${USERNAME}"

exit 0
