# Windows Setup
In general, the usability of a Yubikey in Windows is not as easy as it should be. But worry not! We've got you covered. This guide includes everything necessary to setup your environments to work with your hardware-key seamlessly (gpg-wise at least).

## What
This setup enables you to setup your gpg agents in a way, so they can make use of gpg subkeys stored on your smartcard in an effortless manner.
After completing this setup you'll be able to use your smartcard as the single source of gpg keys in both, your Windows OS as well as WSL2 distributions installed on it. Here we will utilize 2 different kinds of pageants:
* https://github.com/benpye/wsl-ssh-pageant - to setup your host OS (Windows itself)
* https://github.com/BlackReloaded/wsl2-ssh-pageant - to setup your guest OS in WSL2

## How
There's 2 ways doing this:
- The autoamted way -> a script which copies configs all around the place
- The manual way -> copying the configs yourself (as fallback, if above's script doesn't work)
Both need a restart of your OS at the end to confirm, that everything works out-of-the-box.

### Requirements

* Windows 10 or higher
* Windows Powershell (should be a no brainer)
* Local Admin permissions on your machine
* As of now you still have to have the `chocolatey` package manager installed [from here](https://chocolatey.org/install).

### Automated Setup

1. Run the setup script using Powershell `.\security\yubi\windows\setup-yubi-windows.ps1` -> asks for Admin privileges
2. Start a new PowerShell session (loads new functions) and Run `reload-pageant`

> [!TIP]
> The first time running the `yubi-wsl-ssh-pageant.vbs` script from your Startup folder will pop up a `Security Warning` dialog. Make sure to __UNCHECK__ the box `Always ask before opening this file` to make the user experience more seamless.

tbd -> git setup for signing commits (key download from keyserver, upload to git and git settings)

### Manual Setup
tbd


## Troubleshooting
> [!IMPORTANT]  
> This section assumes you already tried one of the above's [ways to setup](#how) your environment.

There are some common errors when handling a Smartcard GPG setup. We collect them here in a chronological order as of when in the setup process (of the manual one) they might occur.


> :warning: `ssh-add -L` fails with: `error fetching identities: agent refused operation`

In this case it's very likely your gpg-agent needs a restart due to some configuration changes:
```powershell
# graceful reload
restart-gpg-agent
# OR
# forceful reload
restart-force-gpg-agent
```

> :warning: `ssh-add -L` fails with: `Error connecting to agent: No such file or directory`

Seems like your wsl-ssh-pageant didn't start properly. You can start it using the following command:
```powershell
start-pageant
```

## Todo's
* [ ] Create cleanup scripts to remove everything
