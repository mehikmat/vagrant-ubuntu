#!/bin/bash

#### passwordless sudo
echo "%sudo   ALL=NOPASSWD: ALL" >> /etc/sudoers

sed -i '/.*requiretty/d' /etc/sudoers
echo '%vagrant ALL=NOPASSWD: ALL' >> /etc/sudoers

#### speed up ssh
echo "UseDNS no" >> /etc/ssh/sshd_config

#### No fsck at boot
sed -i -r 's/(defaults\s+)1 1/\10 0/' /etc/fstab

#### Install vagrant keys[public ssh key for vagrant user]
mkdir -p /home/vagrant/.ssh
cat <<EOM >/home/vagrant/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8Y\
Vr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdO\
KLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7Pt\
ixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmC\
P3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcW\
yLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
EOM

#### setup correct permissions
chmod 755 /home/vagrant/.ssh
chmod 644 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

#### Setup network devices.
rm /etc/udev/rules.d/70-persistent-net.rules
echo '#' >/etc/udev/rules.d/75-persistent-net-generator.rules

#### setup DNS records
cat <<EOM >>/etc/hosts
127.0.0.1   vagrant-ubuntu1304.com vagrant-ubuntu1304
::1         vagrant-ubuntu1304.com vagrant-ubuntu1304
EOM

#### Install Ansible and dependencies
# First Install Distribute
curl -O http://python-distribute.org/distribute_setup.py 
python distribute_setup.py
rm -f distribute_setup.py

# Second Install Pip
curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py -O
python get-pip.py
rm -f get-pip.py

# Third Install Ansible
sudo apt-get install -y python-dev
sudo pip install paramiko PyYAML jinja2 httplib2    
sudo pip install ansible

#### install tools
# build-essential nfs-common dkms curl wget openssh-server openssh-client man are already installed
sudo apt-get install bzr mercurial

#### VirtualBox Guest Additions
mount /dev/cdrom /mnt
/mnt/VBoxLinuxAdditions.run
chkconfig vboxadd-x11 off
umount /mnt/

#### display login promt after boot
sed "s/quiet splash//" /etc/default/grub > /tmp/grub
mv /tmp/grub /etc/default/grub
update-grub

#### clean up
apt-get clean
