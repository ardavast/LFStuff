#!/bin/bash

yum -y install bison gcc gcc-c++ patch perl texinfo wget xz

#Chapter 2
sfdisk /dev/sdb -uM << EOF
,512
,512,S
;
EOF

mkfs -v -t ext4 /dev/sdb1
mkswap /dev/sdb2
mkfs -v -t ext4 /dev/sdb3

LFS=/mnt/lfs

mkdir -pv $LFS
mount -v -t ext4 /dev/sdb3 $LFS
mkdir -v $LFS/boot
mount -v -t ext4 /dev/sdb1 $LFS/boot

#Chapter 3
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
wget -O /root/wget-list https://raw.github.com/ardavast/LFStuff/master/wget-list
wget -O /root/md5sums https://raw.github.com/ardavast/LFStuff/master/md5sums
wget -i /root/wget-list -P $LFS/sources

pushd $LFS/sources
md5sum -c /root/md5sums
popd

#Chapter 4
mkdir -v $LFS/tools
ln -sv $LFS/tools /

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

chown -v lfs $LFS/tools
chown -v lfs $LFS/sources
