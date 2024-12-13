#!/bin/bash

set -euo pipefail

## Install required dependencies
sudo apt update && sudo apt upgrade -y && \
    sudo apt install -y \
    libpam-u2f

# Add Yubikey to accepted authentication methods
mkdir -p ~/.config/Yubico
echo "The setup will ask you for your Yubikey PIN. Enter it and then touch your Yubikey when it starts blinking."
pamu2fcfg > ~/.config/Yubico/u2f_keys

# Enable Yubikey for sudo if not already enabled
if ! grep -q "auth sufficient pam_u2f.so" /etc/pam.d/sudo; then
  echo "Enabling sudo authentication via Yubikey..."
  sudo sed -i '/@include common-auth/i auth sufficient pam_u2f.so' /etc/pam.d/sudo
fi

echo "Authentication via Yubikey enabled for sudo. You can start a new terminal to test it."
