#!/tools/bin/sh

## 6.5
#mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt,run}
#mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
#install -dv -m 0750 /root
#install -dv -m 1777 /tmp /var/tmp
#mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
#mkdir -pv /usr/{,local/}share/{doc,info,locale,man}
#mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
#mkdir -pv /usr/{,local/}share/man/man{1..8}
#for dir in /usr /usr/local; do
#  ln -sv share/{man,doc,info} $dir
#done
#case $(uname -m) in
# x86_64) ln -sv lib /lib64 && ln -sv lib /usr/lib64 && ln -sv lib /usr/local/lib64 ;;
#esac
#mkdir -v /var/{log,mail,spool}
#ln -sv /run /var/run
#ln -sv /run/lock /var/lock
#mkdir -pv /var/{opt,cache,lib/{misc,locate},local}
#
## 6.6
#ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin
#ln -sv /tools/bin/perl /usr/bin
#ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
#ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib
#sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
#ln -sv bash /bin/sh
#
#ln -sv /proc/self/mounts /etc/mtab
#
#cat > /etc/passwd << "EOF"
#root:x:0:0:root:/root:/bin/bash
#bin:x:1:1:bin:/dev/null:/bin/false
#nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
#EOF
#
#cat > /etc/group << "EOF"
#root:x:0:
#bin:x:1:
#sys:x:2:
#kmem:x:3:
#tape:x:4:
#tty:x:5:
#daemon:x:6:
#floppy:x:7:
#disk:x:8:
#lp:x:9:
#dialout:x:10:
#audio:x:11:
#video:x:12:
#utmp:x:13:
#usb:x:14:
#cdrom:x:15:
#mail:x:34:
#nogroup:x:99:
#EOF
#
#touch /var/log/{btmp,lastlog,wtmp}
#chgrp -v utmp /var/log/lastlog
#chmod -v 664  /var/log/lastlog
#chmod -v 600  /var/log/btmp

# 6.7
#cd /sources
#tar Jxf linux-3.10.10.tar.xz
#cd linux-3.10.10
#make mrproper
#make headers_check
#make INSTALL_HDR_PATH=dest headers_install
#find dest/include \( -name .install -o -name ..install.cmd \) -delete
#cp -rv dest/include/* /usr/include
#cd ..
#rm -rf linux-3.10.10

# 6.8
#cd /sources
#tar jxf man-pages-3.53.tar.bz2
#cd man-pages-3.53
#make install
#cd ..
#rm -rf man-pages-3.53

## 6.9.1
#cd /sources
#tar Jxf glibc-2.18.tar.xz
#cd glibc-2.18
#sed -i -e 's/static __m128i/inline &/' sysdeps/x86_64/multiarch/strstr.c
#mkdir -v ../glibc-build
#cd ../glibc-build
#../glibc-2.18/configure       \
#  --prefix=/usr               \
#  --disable-profile           \
#  --enable-kernel=2.6.32      \
#  --libexecdir=/usr/lib/glibc
#make
#make -k check 2>&1 | tee glibc-check-log
#grep Error glibc-check-log
#touch /etc/ld.so.conf
#make install
#cp -v ../glibc-2.18/sunrpc/rpc/*.h /usr/include/rpc
#cp -v ../glibc-2.18/sunrpc/rpcsvc/*.h /usr/include/rpcsvc
#cp -v ../glibc-2.18/nis/rpcsvc/*.h /usr/include/rpcsvc
#mkdir -pv /usr/lib/locale
#localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
#localedef -i de_DE -f ISO-8859-1 de_DE
#localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
#localedef -i de_DE -f UTF-8 de_DE.UTF-8
#localedef -i en_GB -f UTF-8 en_GB.UTF-8
#localedef -i en_HK -f ISO-8859-1 en_HK
#localedef -i en_PH -f ISO-8859-1 en_PH
#localedef -i en_US -f ISO-8859-1 en_US
#localedef -i en_US -f UTF-8 en_US.UTF-8
#localedef -i es_MX -f ISO-8859-1 es_MX
#localedef -i fa_IR -f UTF-8 fa_IR
#localedef -i fr_FR -f ISO-8859-1 fr_FR
#localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
#localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
#localedef -i it_IT -f ISO-8859-1 it_IT
#localedef -i it_IT -f UTF-8 it_IT.UTF-8
#localedef -i ja_JP -f EUC-JP ja_JP
#localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
#localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
#localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
#localedef -i zh_CN -f GB18030 zh_CN.GB18030

# 6.9.2
#cat > /etc/nsswitch.conf << "EOF"
## Begin /etc/nsswitch.conf
#
#passwd: files
#group: files
#shadow: files
#
#hosts: files dns
#networks: files
#
#protocols: files
#services: files
#ethers: files
#rpc: files
#
## End /etc/nsswitch.conf
#EOF
#
#tar -xf ../tzdata2013d.tar.gz
#
#ZONEINFO=/usr/share/zoneinfo
#mkdir -pv $ZONEINFO/{posix,right}
#
#for tz in etcetera southamerica northamerica europe africa antarctica  \
#          asia australasia backward pacificnew solar87 solar88 solar89 \
#          systemv; do
#    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
#    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
#    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
#done
#
#cp -v zone.tab iso3166.tab $ZONEINFO
#zic -d $ZONEINFO -p America/New_York
#unset ZONEINFO

#cp -v --remove-destination /usr/share/zoneinfo/Europe/Sofia \
#    /etc/localtime
#
#cat > /etc/ld.so.conf << "EOF"
## Begin /etc/ld.so.conf
#/usr/local/lib
#/opt/lib
#EOF
#
#cat >> /etc/ld.so.conf << "EOF"
## Add an include directory
#include /etc/ld.so.conf.d/*.conf
#EOF
#mkdir -pv /etc/ld.so.conf.d
#cd ..
#rm -rf glibc-build
#rm -rf glibc-2.18
#
## 6.10
#mv -v /tools/bin/{ld,ld-old}
#mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
#mv -v /tools/bin/{ld-new,ld}
#ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld
#
#gcc -dumpspecs | sed -e 's@/tools@@g'                   \
#    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
#    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
#    `dirname $(gcc --print-libgcc-file-name)`/specs

## 6.11
#cd /sources
#tar Jxf zlib-1.2.8.tar.xz
#cd zlib-1.2.8
#./configure --prefix=/usr
#make
#make check
#make install
#mv -v /usr/lib/libz.so.* /lib
#ln -sfv ../../lib/libz.so.1.2.8 /usr/lib/libz.so
#cd ..
#rm -rf zlib-1.2.8
#
## 6.12
#cd /sources
#tar zxf file-5.14.tar.gz
#cd file-5.14
#./configure --prefix=/usr
#make
#make check
#make install
#cd ..
#rm -rf file-5.14

## 6.13
#cd /sources
#tar jxf binutils-2.23.2.tar.bz2
#cd binutils-2.23.2
#rm -fv etc/standards.info
#sed -i.bak '/^INFO/s/standards.info //' etc/Makefile.in
#sed -i -e 's/@colophon/@@colophon/' \
#       -e 's/doc@cygnus.com/doc@@cygnus.com/' bfd/doc/bfd.texinfo
#mkdir -v ../binutils-build
#cd ../binutils-build
#../binutils-2.23.2/configure --prefix=/usr --enable-shared
#make tooldir=/usr
#make check
#make tooldir=/usr install
#cp -v ../binutils-2.23.2/include/libiberty.h /usr/include
#cd ..
#rm -rf binutils-build
#rm -rf binutils-2.23.2

## 6.14
#cd /sources
#tar Jxf gmp-5.1.2.tar.xz
#cd gmp-5.1.2
#./configure --prefix=/usr --enable-cxx
#make
#make check 2>&1 | tee gmp-check-log
#awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log
#make install
#mkdir -v /usr/share/doc/gmp-5.1.2
#cp    -v doc/{isa_abi_headache,configuration} doc/*.html \
#         /usr/share/doc/gmp-5.1.2
#cd ..
#rm -rf gmp-5.1.2
#
## 6.15
#cd /sources
#tar Jxf mpfr-3.1.2.tar.xz
#cd mpfr-3.1.2
#./configure  --prefix=/usr        \
#             --enable-thread-safe \
#             --docdir=/usr/share/doc/mpfr-3.1.2
#make
#make check
#make install
#make html
#make install-html
#cd ..
#rm -rf mpfr-3.1.2

# 6.16
#cd /sources
#tar zxf mpc-1.0.1.tar.gz
#cd mpc-1.0.1
#./configure --prefix=/usr
#make
#make check
#make install
#cd ..
#rm -rf mpc-1.0.1

# 6.17
#cd /sources
#tar jxf gcc-4.8.1.tar.bz2
#cd gcc-4.8.1
#case `uname -m` in
#  i?86) sed -i 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in ;;
#esac
#sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in
#sed -i -e /autogen/d -e /check.sh/d fixincludes/Makefile.in 
#mv -v libmudflap/testsuite/libmudflap.c++/pass41-frag.cxx{,.disable}
#mkdir -v ../gcc-build
#cd ../gcc-build
#../gcc-4.8.1/configure --prefix=/usr               \
#                       --libexecdir=/usr/lib       \
#                       --enable-shared             \
#                       --enable-threads=posix      \
#                       --enable-__cxa_atexit       \
#                       --enable-clocale=gnu        \
#                       --enable-languages=c,c++    \
#                       --disable-multilib          \
#                       --disable-bootstrap         \
#                       --disable-install-libiberty \
#                       --with-system-zlib
#make
#ulimit -s 32768
#make -k check
#../gcc-4.8.1/contrib/test_summary
#make install
#ln -sv ../usr/bin/cpp /lib
#ln -sv gcc /usr/bin/cc
#mkdir -pv /usr/share/gdb/auto-load/usr/lib
#mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
#cd ..
#rm -rf gcc-build
#rm -rf gcc-4.8.1

# 6.18
#cd /sources
#tar jxf sed-4.2.2.tar.bz2
#cd sed-4.2.2
#./configure --prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-4.2.2
#make
#make html
#make check
#make install
#make -C doc install-html
#cd ..
#rm -rf sed-4.2.2

# 6.19
#cd /sources
#tar zxf bzip2-1.0.6.tar.gz
#cd bzip2-1.0.6
#patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
#sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
#sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
#make -f Makefile-libbz2_so
#make clean
#make
#make PREFIX=/usr install
#cp -v bzip2-shared /bin/bzip2
#cp -av libbz2.so* /lib
#ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
#rm -v /usr/bin/{bunzip2,bzcat,bzip2}
#ln -sv bzip2 /bin/bunzip2
#ln -sv bzip2 /bin/bzcat
#cd ..
#rm -rf bzip2-1.0.6

# 6.20
#cd /sources
#tar zxf pkg-config-0.28.tar.gz
#cd pkg-config-0.28
#./configure --prefix=/usr         \
#            --with-internal-glib  \
#            --disable-host-tool   \
#            --docdir=/usr/share/doc/pkg-config-0.28
#make
#make check
#make install
#cd ..
#rm -rf pkg-config-0.28

# 6.21
#cd /sources
#tar zxf ncurses-5.9.tar.gz
#cd ncurses-5.9
#./configure --prefix=/usr           \
#            --mandir=/usr/share/man \
#            --with-shared           \
#            --without-debug         \
#            --enable-pc-files       \
#            --enable-widec
#make
#make install
#mv -v /usr/lib/libncursesw.so.5* /lib
#ln -sfv ../../lib/libncursesw.so.5 /usr/lib/libncursesw.so
#for lib in ncurses form panel menu ; do
#    rm -vf                    /usr/lib/lib${lib}.so
#    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
#    ln -sfv lib${lib}w.a      /usr/lib/lib${lib}.a
#    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
#done
#ln -sfv libncurses++w.a /usr/lib/libncurses++.a
#rm -vf                     /usr/lib/libcursesw.so
#echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
#ln -sfv libncurses.so      /usr/lib/libcurses.so
#ln -sfv libncursesw.a      /usr/lib/libcursesw.a
#ln -sfv libncurses.a       /usr/lib/libcurses.a
#mkdir -v       /usr/share/doc/ncurses-5.9
#cp -v -R doc/* /usr/share/doc/ncurses-5.9
#cd ..
#rm -rf ncurses-5.9

# 6.22
#cd /sources
#tar jxf shadow-4.1.5.1.tar.bz2
#cd shadow-4.1.5.1
#sed -i 's/groups$(EXEEXT) //' src/Makefile.in
#find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
#sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
#       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
#sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' \
#    etc/login.defs
#./configure --sysconfdir=/etc
#make
#make install
#mv -v /usr/bin/passwd /bin
#pwconv
#grpconv
#echo "root:root" | chpasswd
#cd ..
#rm -rf shadow-4.1.5.1

## 6.23
#cd /sources
#tar Jxf util-linux-2.23.2.tar.xz
#cd util-linux-2.23.2
#sed -i -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
#     $(grep -rl '/etc/adjtime' .)
#mkdir -pv /var/lib/hwclock
#./configure --disable-su --disable-sulogin --disable-login
#make
#make install
#cd ..
#rm -rf util-linux-2.23.2

## 6.24
#cd /sources
#tar zxf psmisc-22.20.tar.gz
#cd psmisc-22.20
#./configure --prefix=/usr
#make
#make install
#mv -v /usr/bin/fuser   /bin
#mv -v /usr/bin/killall /bin
#cd ..
#rm -rf psmisc-22.20
#
## 6.25
#cd /sources
#tar Jxf procps-ng-3.3.8.tar.xz
#cd procps-ng-3.3.8
#./configure --prefix=/usr                           \
#            --exec-prefix=                          \
#            --libdir=/usr/lib                       \
#            --docdir=/usr/share/doc/procps-ng-3.3.8 \
#            --disable-static                        \
#            --disable-skill                         \
#            --disable-kill
#make
#sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
#make check
#make install
#mv -v /usr/lib/libprocps.so.* /lib
#ln -sfv ../../lib/libprocps.so.1.1.2 /usr/lib/libprocps.so
#cd ..
#rm -rf procps-ng-3.3.8

## 6.26
#cd /sources
#tar zxf e2fsprogs-1.42.8.tar.gz
#cd e2fsprogs-1.42.8
#sed -i -e 's/mke2fs/$MKE2FS/' -e 's/debugfs/$DEBUGFS/' tests/f_extent_oobounds/script
#mkdir -v build
#cd build
#../configure --prefix=/usr         \
#             --with-root-prefix="" \
#             --enable-elf-shlibs   \
#             --disable-libblkid    \
#             --disable-libuuid     \
#             --disable-uuidd       \
#             --disable-fsck
#make
#make check
#make install
#make install-libs
#chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
#gunzip -v /usr/share/info/libext2fs.info.gz
#install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
#makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
#install -v -m644 doc/com_err.info /usr/share/info
#install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
#cd ..
#rm -rf e2fsprogs-1.42.8

## 6.27
#cd /sources
#tar Jxf coreutils-8.21.tar.xz
#cd coreutils-8.21
#patch -Np1 -i ../coreutils-8.21-i18n-1.patch
#FORCE_UNSAFE_CONFIGURE=1 ./configure \
#            --prefix=/usr            \
#            --libexecdir=/usr/lib    \
#            --enable-no-install-program=kill,uptime
#make
#make NON_ROOT_USERNAME=nobody check-root
#echo "dummy:x:1000:nobody" >> /etc/group
#chown -Rv nobody . 
#su nobody -s /bin/bash \
#          -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
#sed -i '/dummy/d' /etc/group
#make install
#mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
#mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
#mv -v /usr/bin/{rmdir,stty,sync,true,uname,test,[} /bin
#mv -v /usr/bin/chroot /usr/sbin
#mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
#sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
#mv -v /usr/bin/{head,sleep,nice} /bin
#cd ..
#rm -rf coreutils-8.21

## 6.28
#cd /sources
#tar jxf iana-etc-2.30.tar.bz2
#cd iana-etc-2.30
#make
#make install
#cd ..
#rm -rf iana-etc-2.30

## 6.29
#cd /sources
#tar jxf m4-1.4.16.tar.bz2
#cd m4-1.4.16
#sed -i -e '/gets is a/d' lib/stdio.in.h
#./configure --prefix=/usr
#make
#sed -i -e '41s/ENOENT/& || errno == EINVAL/' tests/test-readlink.h
#make check
#make install
#cd ..
#rm -rf m4-1.4.16

## 6.30
#cd /sources
#tar jxf flex-2.5.37.tar.bz2
#cd flex-2.5.37
#sed -i -e '/test-bison/d' tests/Makefile.in
#./configure --prefix=/usr \
#            --docdir=/usr/share/doc/flex-2.5.37
#make
#make check
#make install
#ln -sv libfl.a /usr/lib/libl.a
#cat > /usr/bin/lex << "EOF"
##!/bin/sh
## Begin /usr/bin/lex
#
#exec /usr/bin/flex -l "$@"
#
## End /usr/bin/lex
#EOF
#chmod -v 755 /usr/bin/lex
#cd ..
#rm -rf flex-2.5.37

## 6.31
#cd /sources
#tar Jxf bison-3.0.tar.xz
#cd bison-3.0
#./configure --prefix=/usr
#make
#make check
#make install
#cd ..
#rm -rf bison-3.0

##6.32
#cd /sources
#tar Jxf grep-2.14.tar.xz
#cd grep-2.14
#./configure --prefix=/usr --bindir=/bin
#make
#make check
#make install
#cd ..
#rm -rf grep-2.14

#6.33
cd /sources
tar zxf readline-6.2.tar.gz
cd readline-6.2
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
patch -Np1 -i ../readline-6.2-fixes-1.patch
./configure --prefix=/usr --libdir=/lib
make SHLIB_LIBS=-lncurses
make install
mv -v /lib/lib{readline,history}.a /usr/lib
rm -v /lib/lib{readline,history}.so
ln -sfv ../../lib/libreadline.so.6 /usr/lib/libreadline.so
ln -sfv ../../lib/libhistory.so.6 /usr/lib/libhistory.so
mkdir   -v       /usr/share/doc/readline-6.2
install -v -m644 doc/*.{ps,pdf,html,dvi} \
                 /usr/share/doc/readline-6.2
cd ..
rm -rf readline-6.2
