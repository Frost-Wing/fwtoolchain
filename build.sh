#!/usr/bin/env bash
set -e

# --- CONFIG ---
PREFIX=/opt/fwtoolchain
TARGET=x86_64-elf
JOBS=$(nproc)

BINUTILS_VERSION=2.42
GCC_VERSION=13.2.0

# --- STEP 0: Install prerequisites ---
echo "[*] Installing prerequisites..."
sudo apt update
sudo apt install -y build-essential bison flex libgmp3-dev libmpfr-dev libmpc-dev texinfo libisl-dev wget

# --- STEP 1: Build binutils ---
echo "[*] Downloading binutils..."
wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
tar xvf binutils-$BINUTILS_VERSION.tar.gz
mkdir -p build-binutils && cd build-binutils

echo "[*] Configuring binutils..."
../binutils-$BINUTILS_VERSION/configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-werror
make -j$JOBS
make install
cd ..

# --- STEP 2: Build GCC ---
echo "[*] Downloading GCC..."
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
tar xvf gcc-$GCC_VERSION.tar.gz
mkdir -p build-gcc && cd build-gcc

echo "[*] Configuring GCC..."
../gcc-$GCC_VERSION/configure --target=$TARGET --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j$JOBS
make all-target-libgcc -j$JOBS
make install-gcc
make install-target-libgcc
cd ..

# --- STEP 3: Create custom names ---
echo "[*] Creating custom tool names..."
cd $PREFIX/bin
ln -sf $TARGET-gcc fwgcc
ln -sf $TARGET-g++ fwg++
ln -sf $TARGET-ld fwld
ln -sf $TARGET-as fwas
ln -sf $TARGET-ar fwar
ln -sf $TARGET-objcopy fwobjcopy
ln -sf $TARGET-objdump fwobjdump
ln -sf $TARGET-nm fwnm

# --- STEP 4: Update PATH ---
echo "[*] Adding $PREFIX/bin to PATH..."
if ! grep -q "$PREFIX/bin" ~/.bashrc; then
    echo "export PATH=\$PATH:$PREFIX/bin" >> ~/.bashrc
fi

echo "[*] fwtoolchain installed successfully!"
echo "Restart your terminal or run: source ~/.bashrc"
echo "Test: fwgcc --version"
