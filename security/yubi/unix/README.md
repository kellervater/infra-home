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
# If you've downloaded the repository
./setup_yubi.sh
# or if you want to directly execute it
curl https://raw.githubusercontent.com/kellervater/infra-home/refs/heads/main/security/yubi/unix/setup_yubi.sh | bash
```

## PAM Setup

> [!Caution]
> Despite being well-tested, these kind of scripts can mess up your sudo settings.
> I recommend opening another terminal session with elevated privileges and keep it open until this process succeeds.

> [!Important]
> Your Yubikey needs to be plugged in for this to work!

If you want to enjoy passwordless `sudo` by only touching your Yubikey, you can use this script:
```shell
# Execute locally
./setup_pam.sh
```

During the execution you'll be prompted to interact:
* Enter you Yubi-PIN
* Touch the Yubikey
