# GPG Smartcard Setup on Linux
This guide describes how to configure your unix-based distro to work with gpg keys from a hardware key (e.g. Yubikey).

## Assumptions

> [!NOTE]
> You can check your smartcard data by plugging it in and type: `gpg --card-status`. (`scdaemon` has to be installed)

The script [setup_yubi.sh](./setup_yubi.sh) assumes you have a smartcard with following prerequisites:
* `Login data` set to your github username (e.g. kellervater)
* all public gpg keys on your hardware key are exposed via said Github username (e.g. https://github.com/kellervater.gpg)

## Automated script
If above's assumptions are fullfilled you can simply run the script [setup_yubi.sh](./setup_yubi.sh):
```shell
./setup_yubi.sh
```
