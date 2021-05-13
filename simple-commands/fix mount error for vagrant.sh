# Fix 1
## from host 
vagrant plugin install vagrant-vbguest

# Fix 2
## from remote
ls -lh /sbin/mount.vboxsf
sudo ln -sf /opt/VBoxGuestAdditions-*/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf


# Fix 3
## from remote
cd /opt
sudo wget -c http://download.virtualbox.org/virtualbox/5.1.28/VBoxGuestAdditions_5.1.28.iso -O VBoxGuestAdditions_5.1.28.iso
sudo mount VBoxGuestAdditions_5.1.28.iso -o loop /mnt
sudo sh /mnt/VBoxLinuxAdditions.run