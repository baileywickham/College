sudo dnf install -y cmake make git gcc elfutils-devel elfutils-libs elfutils-libelf ncurses-devel
git clone https://github.com/acmel/dwarves.git
mkdir dwarves/build
cd dwarves/build
cmake -D__LIB=lib ..
sudo make install
