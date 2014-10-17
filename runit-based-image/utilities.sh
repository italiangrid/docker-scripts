#!/bin/bash
set -e
source /build/buildconfig
set -x

## Often used tools.
$minimal_yum_install xz curl less vim 

# python dependencies
$minimal_yum_install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

# Python 3.3.5:
wget http://python.org/ftp/python/3.3.5/Python-3.3.5.tar.xz
tar xf Python-3.3.5.tar.xz
cd Python-3.3.5
./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall

# make link for the my_init.sh script
ln -s /usr/local/bin/python3.3 /usr/bin/python3

## This tool runs a command as another user and sets $HOME.
cp /build/bin/setuser /sbin/setuser
