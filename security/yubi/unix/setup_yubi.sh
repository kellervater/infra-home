#!/bin/bash
# This script has been successfully tested on Debian 12 (as of 20.09.2024)

set -eo pipefail

# Dependencies
sudo apt update && sudo apt upgrade -y && \
    sudo apt install -y \
    scdaemon

# Path Magic
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
# to not unnecessarily pollute the .bashrc file we'll only reference another rc
mkdir -p ~/.bashrc.d
cp "${SCRIPT_DIR}/.yubirc" ~/.bashrc.d/
YUBI_LINE=". ~/.bashrc.d/.yubirc"
grep -qF "${YUBI_LINE}" ~/.bashrc || sh -c "echo '${YUBI_LINE}' >> ~/.bashrc"

# Verify subscript
echo
. ~/.bashrc.d/.yubirc
ssh-add -L
echo "ℹ️ NOTE: You may need to restart another shell for this to take effect!"

# TODO: it probably makes sense to do a gh auth login or similar
read -p "Enter Github username: " GH_USER
gpg --import <(curl -s https://github.com/${GH_USER}.gpg)
echo "something" > file.txt
gpg --sign file.txt
rm -rf file.txt*

# Global Git Config
CARDHOLDER_NAME=$(gpg --card-status | grep 'Name of cardholder' | awk -F ': ' '{print $2}')
CARDHOLDER_EMAIL=$(gpg --card-status | grep 'General key info' | awk -F '[<>]' '{print $2}')

git config --global user.name $CARDHOLDER_NAME
git config --global user.email $CARDHOLDER_EMAIL
git config --global commit.gpgSign true