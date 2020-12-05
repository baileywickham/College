#https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/tree/get-verified-tarball
sudo dnf install -y git elfutils-devel elfutils-libs elfutils-libelf ncurses-devel bison flex elfutils-libelf-devel openssl-devel cmake
sudo dnf group install -y "Development Tools"

export KERNEL="5.8.11"

sudo yum install -y bison flex elfutils-libelf-devel openssl-devel elfutils-devel make gcc perl

gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org

curl -OL "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL}.tar.xz"
curl -OL "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL}.tar.sign"
xz -cd "linux-${KERNEL}.tar.xz" | gpg2 --verify "linux-${KERNEL}.tar.sign -"
gpg2 --verify "linux-${KERNEL}.tar.sign"

tar -xf "linux-${KERNEL}.tar.xz" && rm "linux-${KERNEL}.tar.xz"
cd "linux-${KERNEL}"
yes "" | make -j2 localmodconfig

# CONFIG_DEBUG_INFO_BTF

#sudo dnf group install -y "Development Tools"
sudo make -j2
sudo make modules
sudo make module_install
sudo rm /etc/dracut.conf.d/xen.conf # remove this ot needed file
sudo make install

sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grubby --set-default "/boot/vmlinuz-${KERNEL}"
