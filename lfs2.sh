#!/bin/bash

LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
MAKEFLAGS='-j4'
export LFS LC_ALL LFS_TGT PATH

# Chapter 4
#cat > ~/.bash_profile << "EOF"
#exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
#EOF

#cat > ~/.bashrc << "EOF"
#set +h
#umask 022
#LFS=/mnt/lfs
#LC_ALL=POSIX
#LFS_TGT=$(uname -m)-lfs-linux-gnu
#PATH=/tools/bin:/bin:/usr/bin
#export LFS LC_ALL LFS_TGT PATH
#EOF

#source ~/.bash_profile

# Chapter 5
#cd $LFS/sources
#tar jxvf binutils-2.23.2.tar.bz2
#cd binutils-2.23.2
#sed -i -e 's/@colophon/@@colophon/' \
#       -e 's/doc@cygnus.com/doc@@cygnus.com/' bfd/doc/bfd.texinfo
#mkdir -v ../binutils-build
#cd ../binutils-build
#../binutils-2.23.2/configure \
#--prefix=/tools              \
#--with-sysroot=$LFS          \
#--with-lib-path=/tools/lib   \
#--target=$LFS_TGT            \
#--disable-nls                \
#--disable-werror
#make
#
#case $(uname -m) in
#x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
#esac
#
#make install
#cd ..
#rm -rf binutils-build
#rm -rf binutils-2.23.2

#cd $LFS/sources
#tar jxvf /mnt/lfs/sources/gcc-4.8.1.tar.bz2
#cd gcc-4.8.1
#tar Jxvf ../mpfr-3.1.2.tar.xz
#mv -v mpfr-3.1.2 mpfr
#tar Jxvf ../gmp-5.1.2.tar.xz
#mv -v gmp-5.1.2 gmp
#tar zxvf ../mpc-1.0.1.tar.gz
#mv -v mpc-1.0.1 mpc
#for file in \
#  $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
#do
#  cp -uv $file{,.orig}
#  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
#      -e 's@/usr@/tools@g' $file.orig > $file
#  echo '
#  #undef STANDARD_STARTFILE_PREFIX_1
#  #undef STANDARD_STARTFILE_PREFIX_2
#  #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#  #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
#  touch $file.orig
#done
#sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure
#mkdir -v ../gcc-build
#cd ../gcc-build
#../gcc-4.8.1/configure                           \
#--target=$LFS_TGT                                \
#--prefix=/tools                                  \
#--with-sysroot=$LFS                              \
#--with-newlib                                    \
#--without-headers                                \
#--with-local-prefix=/tools                       \
#--with-native-system-header-dir=/tools/include   \
#--disable-nls                                    \
#--disable-shared                                 \
#--disable-multilib                               \
#--disable-decimal-float                          \
#--disable-threads                                \
#--disable-libatomic                              \
#--disable-libgomp                                \
#--disable-libitm                                 \
#--disable-libmudflap                             \
#--disable-libquadmath                            \
#--disable-libsanitizer                           \
#--disable-libssp                                 \
#--disable-libstdc++-v3                           \
#--enable-languages=c,c++                         \
#--with-mpfr-include=$(pwd)/../gcc-4.8.1/mpfr/src \
#--with-mpfr-lib=$(pwd)/mpfr/src/.libs
#make
#make install
#ln -sv libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`
#cd ..
#rm -rf gcc-build
#rm -rf gcc-4.8.1

#cd $LFS/sources
#tar Jxvf linux-3.10.10.tar.xz
#cd linux-3.10.10
#make mrproper
#make headers_check
#make INSTALL_HDR_PATH=dest headers_install
#cp -rv dest/include/* /tools/include
#cd ..
#rm -rf linux-3.10.10

#cd $LFS/sources
#tar Jxvf glibc-2.18.tar.xz
#cd glibc-2.18
#sed -i -e 's/static __m128i/inline &/' sysdeps/x86_64/multiarch/strstr.c
#mkdir -v ../glibc-build
#cd ../glibc-build
#../glibc-2.18/configure                           \
#    --prefix=/tools                               \
#    --host=$LFS_TGT                               \
#    --build=$(../glibc-2.18/scripts/config.guess) \
#    --disable-profile                             \
#    --enable-kernel=2.6.32                        \
#    --with-headers=/tools/include                 \
#    libc_cv_forced_unwind=yes                     \
#    libc_cv_ctors_header=yes                      \
#    libc_cv_c_cleanup=yes
#make
#make install
#cd ..
#rm -rf glibc-build
#rm -rf glibc-2.18

#cd $LFS/sources
#tar jxvf /mnt/lfs/sources/gcc-4.8.1.tar.bz2
#cd gcc-4.8.1
#mkdir -pv ../gcc-build
#cd ../gcc-build
#../gcc-4.8.1/libstdc++-v3/configure \
#    --host=$LFS_TGT                      \
#    --prefix=/tools                      \
#    --disable-multilib                   \
#    --disable-shared                     \
#    --disable-nls                        \
#    --disable-libstdcxx-threads          \
#    --disable-libstdcxx-pch              \
#    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/4.8.1
#make
#make install
#cd ..
#rm -rf gcc-build
#rm -rf gcc-4.8.1

#cd $LFS/sources
#tar jxvf binutils-2.23.2.tar.bz2
#cd binutils-2.23.2
#sed -i -e 's/@colophon/@@colophon/' \
#       -e 's/doc@cygnus.com/doc@@cygnus.com/' bfd/doc/bfd.texinfo
#mkdir -v ../binutils-build
#CC=$LFS_TGT-gcc                \
#AR=$LFS_TGT-ar                 \
#RANLIB=$LFS_TGT-ranlib         \
#../binutils-2.23.2/configure   \
#    --prefix=/tools            \
#    --disable-nls              \
#    --with-lib-path=/tools/lib \
#    --with-sysroot
#make
#make install
#make -C ld clean
#make -C ld LIB_PATH=/usr/lib:/lib
#cp -v ld/ld-new /tools/bin
#cd ..
#rm -rf binutils-build
#rm -rf binutils-2.23.2

#cd $LFS/sources
#tar jxvf /mnt/lfs/sources/gcc-4.8.1.tar.bz2
#cd gcc-4.8.1
#
#cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
#  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
#
#cp -v gcc/Makefile.in{,.tmp}
#sed 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in.tmp \
#  > gcc/Makefile.in
#
#for file in \
# $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
#do
#  cp -uv $file{,.orig}
#  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
#  -e 's@/usr@/tools@g' $file.orig > $file
#  echo '
##undef STANDARD_STARTFILE_PREFIX_1
##undef STANDARD_STARTFILE_PREFIX_2
##define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
##define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
#  touch $file.orig
#done
#
#tar Jxvf ../mpfr-3.1.2.tar.xz
#mv -v mpfr-3.1.2 mpfr
#tar Jxvf ../gmp-5.1.2.tar.xz
#mv -v gmp-5.1.2 gmp
#tar zxvf ../mpc-1.0.1.tar.gz
#mv -v mpc-1.0.1 mpc
#
#mkdir -v ../gcc-build
#cd ../gcc-build
#CC=$LFS_TGT-gcc                                      \
#CXX=$LFS_TGT-g++                                     \
#AR=$LFS_TGT-ar                                       \
#RANLIB=$LFS_TGT-ranlib                               \
#../gcc-4.8.1/configure                               \
#    --prefix=/tools                                  \
#    --with-local-prefix=/tools                       \
#    --with-native-system-header-dir=/tools/include   \
#    --enable-clocale=gnu                             \
#    --enable-shared                                  \
#    --enable-threads=posix                           \
#    --enable-__cxa_atexit                            \
#    --enable-languages=c,c++                         \
#    --disable-libstdcxx-pch                          \
#    --disable-multilib                               \
#    --disable-bootstrap                              \
#    --disable-libgomp                                \
#    --with-mpfr-include=$(pwd)/../gcc-4.8.1/mpfr/src \
#    --with-mpfr-lib=$(pwd)/mpfr/src/.libs
#make
#make install
#ln -sv gcc /tools/bin/cc
#cd ..
#rm -rf gcc-build
#rm -rf gcc-4.8.1

# 5.11
#cd $LFS/sources
#tar zxvf tcl8.6.0-src.tar.gz
#cd tcl8.6.0
#sed -i s/500/5000/ generic/regc_nfa.c
#cd unix
#./configure --prefix=/tools
#make
#TZ=UTC make test
#make install
#chmod -v u+w /tools/lib/libtcl8.6.so
#make install-private-headers
#ln -sv tclsh8.6 /tools/bin/tclsh
#cd ..
#rm -rf tcl8.6.0


# 5.12
#cd $LFS/sources
#tar zxvf expect5.45.tar.gz
#cd expect5.45
#cp -v configure{,.orig}
#sed 's:/usr/local/bin:/bin:' configure.orig > configure
#./configure --prefix=/tools --with-tcl=/tools/lib \
#  --with-tclinclude=/tools/include
#make
#make test
#make SCRIPTS="" install
#cd ..
#rm -rf expect5.45
#
## 5.13
#cd $LFS/sources
#tar zxvf dejagnu-1.5.1.tar.gz
#cd dejagnu-1.5.1
#./configure --prefix=/tools
#make install
#make check
#cd ..
#rm -rf dejagnu-1.5.1

#cd $LFS/sources
#tar zxf check-0.9.10.tar.gz
#cd check-0.9.10
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf check-0.9.10
#
#cd $LFS/sources
#tar zxf ncurses-5.9.tar.gz
#cd ncurses-5.9
#./configure --prefix=/tools --with-shared \
#  --without-debug --without-ada --enable-overwrite
#make
#make install
#cd ..
#rm -rf ncurses-5.9
#
#cd $LFS/sources
#tar zxf bash-4.2.tar.gz
#cd bash-4.2
#patch -Np1 -i ../bash-4.2-fixes-12.patch
#./configure --prefix=/tools --without-bash-malloc
#make
#make tests
#make install
#ln -sv bash /tools/bin/sh
#cd ..
#rm -rf bash-4.2
#
#cd $LFS/sources
#tar zxf bzip2-1.0.6.tar.gz
#cd bzip2-1.0.6
#make
#make PREFIX=/tools install
#cd ..
#rm -rf bzip2-1.0.6
#
#cd $LFS/sources
#tar Jxf coreutils-8.21.tar.xz
#cd coreutils-8.21
#./configure --prefix=/tools --enable-install-program=hostname
#make
#make RUN_EXPENSIVE_TESTS=yes check
#make install
#cd ..
#rm -rf coreutils-8.21
#
#cd $LFS/sources
#tar Jxf diffutils-3.3.tar.xz
#cd diffutils-3.3
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf diffutils-3.3
#
#cd $LFS/sources
#tar zxf file-5.14.tar.gz
#cd file-5.14
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf file-5.14
#
#cd $LFS/sources
#tar zxf findutils-4.4.2.tar.gz
#cd findutils-4.4.2
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf findutils-4.4.2
#
#cd $LFS/sources
#tar Jxf gawk-4.1.0.tar.xz
#cd gawk-4.1.0
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf gawk-4.1.0
#
#cd $LFS/sources
#tar zxf gettext-0.18.3.tar.gz
#cd gettext-0.18.3
#cd gettext-tools
#EMACS="no" ./configure --prefix=/tools --disable-shared
#make -C gnulib-lib
#make -C src msgfmt
#cp -v src/msgfmt /tools/bin
#cd ..
#rm -rf gettext-0.18.3
#
#cd $LFS/sources
#tar Jxf grep-2.14.tar.xz
#cd grep-2.14
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf grep-2.14
#
#cd $LFS/sources
#tar Jxf gzip-1.6.tar.xz
#cd gzip-1.6
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf gzip-1.6
#
#cd $LFS/sources
#tar jxf m4-1.4.16.tar.bz2
#cd m4-1.4.16
#sed -i -e '/gets is a/d' lib/stdio.in.h
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf m4-1.4.16
#
#cd $LFS/sources
#tar jxf make-3.82.tar.bz2
#cd make-3.82
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf make-3.82
#
#cd $LFS/sources
#tar Jxf patch-2.7.1.tar.xz
#cd patch-2.7.1
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf patch-2.7.1
#
#cd $LFS/sources
#tar jxf perl-5.18.1.tar.bz2
#cd perl-5.18.1
#patch -Np1 -i ../perl-5.18.1-libc-1.patch
#sh Configure -des -Dprefix=/tools
#make
#cp -v perl cpan/podlators/pod2man /tools/bin
#mkdir -pv /tools/lib/perl5/5.18.1
#cp -Rv lib/* /tools/lib/perl5/5.18.1
#cd ..
#rm -rf perl-5.18.1
#
#cd $LFS/sources
#tar jxf sed-4.2.2.tar.bz2
#cd sed-4.2.2
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf sed-4.2.2
#
#cd $LFS/sources
#tar jxf tar-1.26.tar.bz2
#cd tar-1.26
#sed -i -e '/gets is a/d' gnu/stdio.in.h
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf tar-1.26
#
#cd $LFS/sources
#tar Jxf texinfo-5.1.tar.xz
#cd texinfo-5.1
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf texinfo-5.1
#
#cd $LFS/sources
#tar Jxf xz-5.0.5.tar.xz
#cd xz-5.0.5
#./configure --prefix=/tools
#make
#make check
#make install
#cd ..
#rm -rf xz-5.0.5

# 5.34
#strip --strip-debug /tools/lib/*
#strip --strip-unneeded /tools/{,s}bin/*

#rm -rf /tools/{,share}/{info,man,doc}

# 5.35
chown -R root:root $LFS/tools

# 6.2
mkdir -v $LFS/{dev,proc,sys}

#6.2.1
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

#6.2.2
mount -v --bind /dev $LFS/dev

#6.2.3
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys

if [ -h $LFS/dev/shm ]; then
  link=$(readlink $LFS/dev/shm)
  mkdir -p $LFS/$link
  mount -vt tmpfs shm $LFS/$link
  unset link
else
  mount -vt tmpfs shm $LFS/dev/shm
fi
