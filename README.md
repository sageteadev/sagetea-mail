[![pipeline status](https://gitlab.com/dekkan/dekko/badges/master/pipeline.svg)](https://gitlab.com/dekkan/dekko/commits/master)

<img width="200px" src="Dekko/app/assets/icons/dekko/dekko.png" />

# Dekko 2

Dekko2 is an convergent email client for Ubuntu Touch. It is under active development and usable in its beta form.
Dekko2 lets you add multiple accounts and supports IMAP and SMTP (POP3 is considered experimental) details.

## How to get it

[![OpenStore](https://open-store.io/badges/en_US.png)](https://open-store.io/app/dekko2.dekkoproject)

Or build it yourself following instructions below.

## Building the app:

* install clickable: http://clickable.bhdouglass.com
* build dependency on the host (despite docker):
```
sudo apt-get install qemu-user-static
```
* clone:
```
git clone --recurse-submodules git@gitlab.com:dekkan/dekko.git
```
* connect your device via usb cable
* build and run:
```
cd dekko
clickable
```
## i18n: Translating Dekko into your Language

You can easily contribute to the localization of this project (i.e. the
translation into your language) by visiting (and signing up with) the
Hosted Weblate service:
https://hosted.weblate.org/projects/ubports/dekko/

The localization platform of this project is sponsored by Hosted Weblate
via their free hosting plan for Libre and Open Source Projects.
