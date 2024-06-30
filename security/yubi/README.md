# User
There's only [one guide](https://jardazivny.medium.com/the-ultimate-guide-to-yubikey-on-wsl2-part-1-dce2ff8d7e45)), which covers many aspects of getting gpg "stuff" running on a smartcard for your OS. It's a bit outdated and covers very specifically the WSL2 part. We wanted to create a refreshed version, where the community can also contribute and place questions. We follow a runbook-like approach of combining some automated scripts with as few manual steps as possible.

This folder contains all necessary manuals and scripts to make the user setup for your Smartcard as convenient as possible.

> [!WARNING]  
> The contents are subject to change, since we've already identified many section which could need some improvement.


## Windows
The windows directory contains setup guides and scripts required to get `gpg` running seamlessly from your smart card on Windows itself as well as any WSL2 distro at the same time. This way you don't have to use such tools as `usbipd` or similar.

> [WINDOWS GUIDE](./windows/README.md)

## Unix
Contains simple setup guides for unix based OSs (Linux, MacOS)

TODO
