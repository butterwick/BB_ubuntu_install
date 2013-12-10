# flash ubuntu 13.10 onto BeagleBone v.A6 SD card from Mac OSX 10.7.5

# get image
# on Mac
wget http://s3.armhf.com/debian/saucy/bone/ubuntu-saucy-13.10-armhf-3.8.13-bone30.img.xz
md5 ubuntu-saucy-13.10-armhf-3.8.13-bone30.img.xz
# should be 8173dffeaae12421a5542c3578afdd82

# find location of SD card (here /dev/disk1)
# on Mac
diskutil list
diskutil umountDisk /dev/disk1

# flash SD card
# on Mac
xzcat ubuntu-saucy-13.10-armhf-3.8.13-bone30.img.xz | sudo dd of=/dev/disk1 bs=1m

# now repartition the SD card
# make SD accessible to Ubuntu 12.04 VM
# first chown all partitions as VM user
# on Mac
sudo chown thomasprice /dev/disk1
sudo chown thomasprice /dev/disk1s1
sudo chown thomasprice /dev/disk1s2
# create a VirtualBox vmdk for SD card
# power off (not just suspend) VirtualBox, then
VBoxManage internalcommands createrawvmdk -filename "/Users/thomasprice/VirtualBox VMs/Ubuntu 12.04/sdcard.vmdk" -rawdisk /dev/disk1
diskutil umountDisk /dev/disk1

# now open VirtualBox UI, choose Settings >> Storage >> SATA Controller 
# click the icon to the right and choose Add Hard Disk >> Use existing disk
# then browse to the location of the sdcard.vmdk file specified above.
# If you get errors when starting up your VM, try unmounting the drive again

# from within the VM
# open a terminal and type
mount
# look where the SD card is mounted, here it is /dev/sdb
# now go to the /home folder and eject the SD card partitions to unmount them
sudo su
fdisk -l
# now follow the instructions to expand the linux directory to 4G
# http://www.armhf.com/index.php/expanding-linux-partitions-part-2-of-2/
fdisk /dev/sdb
p
d
2
n
p
2
# resize expanded partition
reboot
resize2fs /dev/sdb2
# now follow the instructions to make new data and fileswap partitions
# http://www.armhf.com/index.php/expanding-linux-partitions-part-1-of-2/
# need to eject the SD card partitions again
fdisk /dev/sdb
# new partition 1G in size
p
n
p
3
7710720
+1024M
# change this partition to a linix swap partition
# http://www.tldp.org/HOWTO/Partition/fdisk_partitioning.html
t
3
82
# 4th and final partition to take up the other 3G
n
p
9807872
15270879
p
w

# Finished formatting SD card
# now plug SD card into beaglebone and wait for it to boot
# then type
# on Mac
screen /dev/tty.usbserial-*B 115200
# usr ubuntu
# pw  ubuntu
