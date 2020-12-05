#!/bin/bash
# p01.sh
# wickham, bailey
# Description
#   p01 installs the newest verison of the kernel.
# Specifications
#   Installs current linux stable kernel source code into given Subdir
#    or ~/src/linux-stable by default.  p01 takes a number of options,
#    as described below.
#
#    With no options, the script downloads the current stable kernel
#    source to the ~/src/linux-stable directory if it is not already
#    there.  If it is already there, the script should respond with the
#    message  "linux-stable already installed".  The default download
#    method must use either curl or wget and get the current stable
#    source code from kernel.org.  The -g option uses git clone for
#    downloading the current stable source from kernel.org.  In either
#    case the source should be pgp verified using the gpg level of
#    ultimate trust to individuals from kernel.org.
#
#    Note that when the install of a new current stable kernel occurs
#    the script should not remove the previous kernel.  But rather it
#    should setup the system so that the next time the system starts
#    it boots using the new current stable kernel version.
#   -g
#       git clone source from kernel.org instead of wget or curl
#   -v
#       Version of new stable kernel but does not install it.
#   -h
#       Help should display options with examples.
#   -D Subdir
#       Subdir is the fullpath of the downloaded source code directory.
#
# Examples
#   p01.sh -D ./src -g
#   p01.sh -v
#   p01.sh -h


# set fail on error
set -e

DIR="${HOME}/src/linux-stable"
# ccache will always be installed in src, -D does not override it.
CCACHEDIR="${HOME}/src/"

help() {
    printf "p01 installs the current linux stable kernel\n"
    printf "\t-g use git to clone\n"
    printf "\t-v print the version\n"
    printf "\t-h print this message\n"
    printf "\t-D specify the subdirectory to clone into\n"
}

install_packages() {
    printf "installing packages\n"
    sudo yum -y update
    sudo yum install -y wget \
        git elfutils-devel elfutils-libs \
        elfutils-libelf ncurses-devel bison flex elfutils-libelf-devel \
        openssl-devel

    sudo yum group install -y "Development Tools"
}

get_link() {
    wget --output-document - --quiet https://www.kernel.org/ | grep -A 1 \
        "latest_link" | awk -F'"' '{print $2}' | tail -n 1

    # needed for my formatter, which is broken
}

get_version() {
    _version=$(get_link | awk -F'-' '{print $2}')
    kernel=${_version%.tar.xz}
    echo $kernel
}

install_curl() {
    printf "installing kernel using curl\n"
    mkdir -p $DIR
    curl -s -OL $(get_link)
    curl -s -OL $(get_link | sed --expression 's/xz/sign/g')
    xz -cd "linux-${KERNEL}.tar.xz" | gpg2 --verify "linux-${KERNEL}.tar.sign" -
    tar -xf "linux-${KERNEL}.tar.xz" --strip-components=1 -C $DIR

    rm "linux-${KERNEL}.tar.xz"
    rm "linux-${KERNEL}.tar.sign"
    cd $DIR
}

install_git() {
    printf "installing kernel using git\n"
    git clone --branch "v${KERNEL}" --depth 1 \
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $DIR

    cd $DIR
    git verify-tag "v${KERNEL}"
    rm -rf .git/
}

install_ccache() {
    mkdir -p $CCACHEDIR
    wget https://github.com/ccache/ccache/releases/download/v3.7.11/ccache-3.7.11.tar.xz
    wget https://github.com/ccache/ccache/releases/download/v3.7.11/ccache-3.7.11.tar.xz.asc
    # this right here is why pgp/gpg never caught on.
    (echo 5; echo y; echo save) | gpg --command-fd 0 \
        --no-tty --no-greeting -q --edit-key joel@debian.org trust

    gpg --keyserver-options auto-key-retrieve \
        --keyserver pgpkeys.mit.edu --verify ccache-3.7.11.tar.xz.asc

    tar -xf ccache-3.7.11.tar.xz -C $CCACHEDIR
    rm ccache-3.7.11.tar.xz
    rm ccache-3.7.11.tar.xz.asc
    cd $CCACHEDIR/ccache-3.7.11
    ./configure && make && sudo make install
}

create_swap() {
    printf "Creating swapfile\n"
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile

    sudo echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab
}

main() {
    if [[ -d $DIR ]] || [[ -d "${CCACHEDIR}/ccache-3.7.11" ]]; then
        printf "linux-stable or ccache is already installed\n"
        exit 1
    fi
    WORKDIR=$(pwd)

    if [[ ! -f "/swapfile" ]]; then
        # Create swapfile if not already created
        create_swap
    fi


    gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org joel@debian.org

    install_packages
    install_ccache
    # Reset to working directory
    cd $WORKDIR

    (echo 5; echo y; echo save) | gpg --command-fd 0 \
        --no-tty --no-greeting -q --edit-key torvalds@kernel.org trust

    KERNEL=$(get_version)
    if [[ -z "$GIT" ]]; then
        install_curl
    else
        install_git
    fi

    yes "" | make -j2 localmodconfig
    sed -i "s/CONFIG_DEBUG_INFO_BTF=y/CONFIG_DEBUG_INFO_BTF=n/g" .config
    make -j$(nproc)

    sudo make modules_install
    sudo rm -rf /etc/dracut.conf.d/xen.conf
    sudo make install

    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    sudo grubby --set-default "/boot/vmlinuz-${KERNEL}"

    printf "reboot to use kernel %s\n" $KERNEL
}

while getopts ":hvgD:" opt; do
    case ${opt} in
        h)
            help
            exit 0
            ;;
        g)
            GIT=true
            ;;
        v)
            get_version
            exit 0
            ;;
        D)
            DIR=${OPTARG}
            ;;
        \?)
            printf "invaid parameter"
            exit 1
            ;;
    esac
done
main
