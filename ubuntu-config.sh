# configure ethernet over USB
# http://automatica.com.au/2009/10/usb-host-to-host-networking-on-the-beagle-board/
# not sure this is working
# on the Beaglebone
sudo modprobe g_ether
sudo vi /etc/network/interfaces
# add the following lines
# auto usb0
# iface usb0 inet static
# address 192.168.7.2
# netmask 255.255.255.0
# gateway 192.168.7.1

# these next few sets of instructions from
# http://embeddedprogrammer.blogspot.com/2012/10/beaglebone-installing-ubuntu-1210.html
# change host name
# on the Beaglebone
sudo vi /etc/hostname
# change name to 'beaglebone'
sudo vi /etc/hosts
# change name on second line to 'beaglebone'

# set password for root account
# pw = admin
sudo passwd -l root

# change default username
# on the Beaglebone
# need to log in as root to do this
usermod -l tom ubuntu
usermod -md /home/tom tom
groupmod -n tom ubuntu

# set up zeroconf hostname
# on the Beaglebone
sudo apt-get update
sudo apt-get install avahi-daemon
# after reboot, can now ssh tom@beaglebone
# when the beaglebone is plugged into the local ethernet

# set time
sudo ntpdate pool.ntp.org

# tool up 
sudo apt-get update
sudo apt-get install vim git build-essential -y

# smoke a bit of python
# install Adafruit_BBIO which seems better supported and easier to install than PyBBIO
# http://learn.adafruit.com/setting-up-io-python-library-on-beaglebone-black/installation-on-ubuntu
sudo ntpdate pool.ntp.org
sudo apt-get update
sudo apt-get install build-essential python-dev libpython2.7-dev python-setuptools python-pip -y
sudo apt-get python-serial python-smbus -y
sudo pip install Adafruit_BBIO
# bugfix
cd /usr/lib/python2.7/
sudo ln -s plat-arm-linux-gnueabihf/_sysconfigdata_nd.py .

# install node.js
# https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#ubuntu-mint
sudo su
cd /usr/bin
apt-get install nodejs npm build-essential curl libssl-dev -y
ln -s nodejs node
curl https://raw.github.com/creationix/nvm/master/install.sh | sh
source ~/.profile
nvm install v0.8.26
# use node v0.8.26 or earlier to install bonescript
# https://github.com/jadonk/bonescript/issues/53
nvm use v.0.8.26
# nvm-fu to export used version to /usr/local (for other users)
# https://www.digitalocean.com/community/articles/how-to-install-node-js-with-nvm-node-version-manager-on-a-vps#installation
n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local
# redirect link to global version
rm node
ln -s /usr/local/bin/node node
exit

# we can now install bonescript wherever we like using
# sudo npm install bonescript

# alternatively clone bonescript version compatible with node v0.10.x
# this is a bit bleeding edge
##cd ~
##git clone https://github.com/fivdi/bonescript
##cd bonescript
##git checkout node-v.0.10
