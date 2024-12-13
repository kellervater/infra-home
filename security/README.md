# Security
This section should cover security related topics which a Software|DevOps|Platform Engineer should know about and adapt in their daily life.

## Hardware Keys
In general security and usability are considered contrary terms. However, there are some companies out there, which try to connect these two worlds without stepping back too much on either side. They create hardware security keys, which a person can use for different kinds of MFA and also to store and use GPG keys for signing, authentication and encryption.

### Setup
If you want to setup a gpg smartcard in a secure way, please check out the following external guide:

> [Admin Setup for Hardware GPG Keys](https://github.com/valiac/schluesselschleuder) 

When you've received a ready-to-use Hardware Key from your company (or done it yourself), you also need to make sure your system works with this key seamlessly. We'll explain how to here:
> [User Setup of Yubikey](./yubi/README.md)

### Vendors?
There are multiple Vendors of hardware keys which support openpgp. Every entry with a :white_check_mark: has been verified to work with this setup: 
* :white_check_mark: [Yubico](https://www.yubico.com) :heavy_plus_sign: Immutable Firmware
* [Nitrokey](https://www.nitrokey.com/products/nitrokeys) :heavy_plus_sign: Open-Source software and firmware
* [Onlykey](https://onlykey.io/) :heavy_plus_sign: open-source firmware, hardware-based password manager
* [Trezor](https://trezor.io/) :heavy_plus_sign: main use-case: hardware crypto wallet

### GPG Use-Cases
TODO: sign commits, authenticate (ssh), encrypt secrets (e.g. via sops)