#!/bin/bash
# This script has been successfully tested on:
# - Debian 12 (last test on 20.09.2024)
# - Ubuntu 24.04 (last test 13.12.2024)

set -euo pipefail

# Dependencies
sudo apt update && sudo apt upgrade -y && \
    sudo apt install -y \
    scdaemon

# Path Magic
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# yubirc
# to not unnecessarily pollute the .bashrc file we'll only reference another rc
mkdir -p ~/.bashrc.d

if [ ! -f "${SCRIPT_DIR}/.yubirc" ]; then
    echo "⚠️ ~/.bashrc.d/.yubirc does not exist locally. Downloading..."
    curl -o ~/.bashrc.d/.yubirc https://raw.githubusercontent.com/kellervater/infra-home/refs/heads/main/security/yubi/unix/.yubirc
else
    echo "ℹ️ ~/.bashrc.d/.yubirc exists locally. Skipping download."
    cp "${SCRIPT_DIR}/.yubirc" ~/.bashrc.d/
fi


YUBI_LINE=". ~/.bashrc.d/.yubirc"
grep -qF "${YUBI_LINE}" ~/.bashrc || sh -c "echo '${YUBI_LINE}' >> ~/.bashrc"

# Verify .bashrc subscript
echo

# shellcheck disable=SC1091
# shellcheck disable=SC1090
. ~/.bashrc.d/.yubirc
ssh-add -L
echo "ℹ️ NOTE: You may need to restart another shell for this to take effect!"

# gpg-agent config
cp "${SCRIPT_DIR}/gpg-agent.conf" ~/.gnupg/gpg-agent.conf
gpg-connect-agent killagent /bye
gpg-connect-agent /bye

# Test Signing
# NOTE: We do assume a github user here.
GPG_USERNAME="$(gpg --card-status | grep 'Login data' | awk -F ': ' '{print $2}')"
gpg --import <(curl -s "https://github.com/${GPG_USERNAME}.gpg")
echo "something" > file.txt
gpg --sign file.txt
rm -rf file.txt*

# Global Git Config
CARDHOLDER_NAME="$(gpg --card-status | grep 'Name of cardholder' | awk -F ': ' '{print $2}')"
CARDHOLDER_EMAIL=$(gpg --card-status | grep 'General key info' | awk -F '[<>]' '{print $2}')
GPG_KEY_ID=$(gpg --card-status | grep -oP 'sub\s+\K[^ ]+' | awk -F '/' '{print $2}')

git config --global user.name "$CARDHOLDER_NAME"
git config --global user.email "$CARDHOLDER_EMAIL"
git config --global commit.gpgSign true
git config --global user.signingkey "$GPG_KEY_ID"
git config --global pull.rebase true
