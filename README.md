Dekko is an email client for Ubuntu Touch

##How to build:
###Prerequesites

```git clone https://gitlab.com/doniks/dekko
git checkout building
git submodule update --init --recursive upstream/
```
(Make sure clickable is set up.)

###Automatic build
`clickable -k 16.04`

###More manual build
Enter a docker shell:

`docker run -v ~/PATH/WHERE/YOU/CLONED/DEKKO:/root/dekko -it clickable/ubuntu-sdk:16.04-armhf bash`

Inside the docker shell:

```cd /root/dekko
./clickable-docker-setup.sh
./build-armhf.sh
click build $BUILD_DIR/**/install-root
```

This will configure the container and build dekko. At the end you should see:

Successfully built package in './dekko2.dekkoproject_X.Y.Z_armhf.click'.

Now connect your UT device with USB cable and run outside of the docker shell:

```clickable install --click dekko2.dekkoproject_0.1.6_armhf.click
clickable launch --click dekko2.dekkoproject_0.1.6_armhf.click
clickable logs --click dekko2.dekkoproject_0.1.6_armhf.click
```

Now dekko should run on your device and you should see the log in the terminal.

