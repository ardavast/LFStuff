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

## 6.32
#cd /sources
#tar Jxf grep-2.14.tar.xz
#cd grep-2.14
#./configure --prefix=/usr --bindir=/bin
#make
#make check
#make install
#cd ..
#rm -rf grep-2.14

# 6.33
#cd /sources
#tar zxf readline-6.2.tar.gz
#cd readline-6.2
#sed -i '/MV.*old/d' Makefile.in
#sed -i '/{OLDSUFF}/c:' support/shlib-install
#patch -Np1 -i ../readline-6.2-fixes-1.patch
#./configure --prefix=/usr --libdir=/lib
#make SHLIB_LIBS=-lncurses
#make install
#mv -v /lib/lib{readline,history}.a /usr/lib
#rm -v /lib/lib{readline,history}.so
#ln -sfv ../../lib/libreadline.so.6 /usr/lib/libreadline.so
#ln -sfv ../../lib/libhistory.so.6 /usr/lib/libhistory.so
#mkdir   -v       /usr/share/doc/readline-6.2
#install -v -m644 doc/*.{ps,pdf,html,dvi} \
#                 /usr/share/doc/readline-6.2
#cd ..
#rm -rf readline-6.2

## 6.34
#cd /sources
#tar zxf bash-4.2.tar.gz
#cd bash-4.2
#patch -Np1 -i ../bash-4.2-fixes-12.patch
#./configure --prefix=/usr                     \
#            --bindir=/bin                     \
#            --htmldir=/usr/share/doc/bash-4.2 \
#            --without-bash-malloc             \
#            --with-installed-readline
#make
#chown -Rv nobody .
#su nobody -s /bin/bash -c "PATH=$PATH make tests"
#make install
#cd ..
#rm -rf bash-4.2

## 6.35
#cd /sources
#tar jxf bc-1.06.95.tar.bz2
#cd bc-1.06.95
#./configure --prefix=/usr --with-readline
#make
#echo "quit" | ./bc/bc -l Test/checklib.b
#make install
#cd ..
#rm -rf bc-1.06.95
#
## 6.36
#cd /sources
#tar zxf libtool-2.4.2.tar.gz
#cd libtool-2.4.2
#./configure --prefix=/usr
#make
#make check
#make install
#cd ..
#rm -rf libtool-2.4.2
#
## 6.37
#cd /sources
#tar zxf gdbm-1.10.tar.gz
#cd gdbm-1.10
#./configure --prefix=/usr --enable-libgdbm-compat
#make
#make check
#make install
#cd ..
#rm -rf gdbm-1.10

## 6.38
#cd /sources
#tar zxf inetutils-1.9.1.tar.gz
#cd inetutils-1.9.1
#sed -i -e '/gets is a/d' lib/stdio.in.h
#./configure --prefix=/usr  \
#    --libexecdir=/usr/sbin \
#    --localstatedir=/var   \
#    --disable-ifconfig     \
#    --disable-logger       \
#    --disable-syslogd      \
#    --disable-whois        \
#    --disable-servers
#make
#make check
#make install
#mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
#cd ..
#rm -rf inetutils-1.9.1
#
## 6.39
#cd /sources
#tar jxf perl-5.18.1.tar.bz2
#cd perl-5.18.1
#echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
#sed -i -e "s|BUILD_ZLIB\s*= True|BUILD_ZLIB = False|"           \
#       -e "s|INCLUDE\s*= ./zlib-src|INCLUDE    = /usr/include|" \
#       -e "s|LIB\s*= ./zlib-src|LIB        = /usr/lib|"         \
#    cpan/Compress-Raw-Zlib/config.in
#sh Configure -des -Dprefix=/usr                 \
#                  -Dvendorprefix=/usr           \
#                  -Dman1dir=/usr/share/man/man1 \
#                  -Dman3dir=/usr/share/man/man3 \
#                  -Dpager="/usr/bin/less -isR"  \
#                  -Duseshrplib
#make
#make -k test
#make install
#cd ..
#rm -rf perl-5.18.1
#
## 6.40
#cd /sources
#tar Jxf autoconf-2.69.tar.xz
#cd autoconf-2.69
#./configure --prefix=/usr
#make
#make check
#make install
#cd ..
#rm -rf autoconf-2.69
#
## 6.41
#cd /sources
#tar Jxf automake-1.14.tar.xz
#cd automake-1.14
#patch -Np1 -i ../automake-1.14-test-1.patch
#./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.14
#make
#make check
#make install
#cd ..
#rm -rf automake-1.14

## 6.42
#cd /sources
#tar Jxf diffutils-3.3.tar.xz
#cd diffutils-3.3
#./configure --prefix=/usr
#make
#make check
#make install
#cd ..
#rm -rf diffutils-3.3
#
## 6.43
#cd /sources
#tar Jxf gawk-4.1.0.tar.xz
#cd gawk-4.1.0
#./configure --prefix=/usr --libexecdir=/usr/lib
#make
#make check
#make install
#mkdir -v /usr/share/doc/gawk-4.1.0
#cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.0
#cd ..
#rm -rf gawk-4.1.0
#
## 6.44
#cd /sources
#tar zxf findutils-4.4.2.tar.gz
#cd findutils-4.4.2
#./configure --prefix=/usr                   \
#            --libexecdir=/usr/lib/findutils \
#            --localstatedir=/var/lib/locate
#make
#make check
#make install
#mv -v /usr/bin/find /bin
#sed -i 's/find:=${BINDIR}/find:=\/bin/' /usr/bin/updatedb
#cd ..
#rm -rf findutils-4.4.2
#
## 6.45
#cd /sources
#tar zxf gettext-0.18.3.tar.gz
#cd gettext-0.18.3
#./configure --prefix=/usr \
#            --docdir=/usr/share/doc/gettext-0.18.3
#make
#make check
#make install
#mv -v /usr/bin/find /bin
#cd ..
#rm -rf gettext-0.18.3
#
## 6.46
#cd /sources
#tar zxf groff-1.22.2.tar.gz
#cd groff-1.22.2
#PAGE=<paper_size> ./configure --prefix=/usr
#make
#mkdir -p /usr/share/doc/groff-1.22/pdf
#make install
#ln -sv eqn /usr/bin/geqn
#ln -sv tbl /usr/bin/gtbl
#cd ..
#rm -rf groff-1.22.2
#
## 6.47
#cd /sources
#tar Jxf xz-5.0.5.tar.xz
#cd xz-5.0.5
#./configure --prefix=/usr --libdir=/lib --docdir=/usr/share/doc/xz-5.0.5
#make
#make check
#make pkgconfigdir=/usr/lib/pkgconfig install
#cd ..
#rm -rf xz-5.0.5
#
## 6.48
#cd /sources
#tar Jxf grub-2.00.tar.xz
#cd grub-2.00
#sed -i -e '/gets is a/d' grub-core/gnulib/stdio.in.h
#./configure --prefix=/usr          \
#            --sysconfdir=/etc      \
#            --disable-grub-emu-usb \
#            --disable-efiemu       \
#            --disable-werror
#make
#make install
#cd ..
#rm -rf grub-2.00
#
## 6.49
#cd /sources
#tar zxf less-458.tar.gz
#cd less-458
#./configure --prefix=/usr --sysconfdir=/etc
#make
#make install
#cd ..
#rm -rf less-458
#
## 6.50
#cd /sources
#tar Jxf gzip-1.6.tar.xz
#cd gzip-1.6
#./configure --prefix=/usr --bindir=/bin
#make
#make check
#make install
#mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin
#mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin
#cd ..
#rm -rf gzip-1.6
#
## 6.51
#cd /sources
#tar Jxf iproute2-3.10.0.tar.xz
#cd iproute2-3.10.0
#sed -i '/^TARGETS/s@arpd@@g' misc/Makefile
#sed -i /ARPD/d Makefile
#sed -i 's/arpd.8//' man/man8/Makefile
#make DESTDIR=
#make DESTDIR=              \
#     MANDIR=/usr/share/man \
#     DOCDIR=/usr/share/doc/iproute2-3.10.0 install
#cd ..
#rm -rf iproute2-3.10.0
#
## 6.52
#cd /sources
#tar zxf kbd-1.15.5.tar.gz
#cd kbd-1.15.5
#patch -Np1 -i ../kbd-1.15.5-backspace-1.patch
#sed -i -e '326 s/if/while/' src/loadkeys.analyze.l
#sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
#sed -i 's/resizecons.8 //' man/man8/Makefile.in
#./configure --prefix=/usr --disable-vlock
#make
#make install
#mkdir -v       /usr/share/doc/kbd-1.15.5
#cp -R -v doc/* /usr/share/doc/kbd-1.15.5
#cd ..
#rm -rf kbd-1.15.5
#
## 6.53
#cd /sources
#tar Jxf kmod-14.tar.xz
#cd kmod-14
#./configure --prefix=/usr       \
#            --bindir=/bin       \
#            --libdir=/lib       \
#            --sysconfdir=/etc   \
#            --disable-manpages  \
#            --with-xz           \
#            --with-zlib
#make
#make check
#make pkgconfigdir=/usr/lib/pkgconfig install
#
#for target in depmod insmod modinfo modprobe rmmod; do
#  ln -sv ../bin/kmod /sbin/$target
#done
#
#ln -sv kmod /bin/lsmod
#cd ..
#rm -rf kmod-14
#
## 6.54
#cd /sources
#tar zxf libpipeline-1.2.4.tar.gz
#cd libpipeline-1.2.4
#PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr
#make
#make check
#make install
#cd ..
#rm -rf libpipeline-1.2.4
#
## 6.55
#cd /sources
#tar jxf make-3.82.tar.bz2
#cd make-3.82
#patch -Np1 -i ../make-3.82-upstream_fixes-3.patch
#./configure --prefix=/usr
#make
#make check
#make install
#cd ..
#rm -rf make-3.82
#
## 6.56
#cd /sources
#tar Jxf man-db-2.6.5.tar.xz
#cd man-db-2.6.5
#./configure --prefix=/usr                        \
#            --libexecdir=/usr/lib                \
#            --docdir=/usr/share/doc/man-db-2.6.5 \
#            --sysconfdir=/etc                    \
#            --disable-setuid                     \
#            --with-browser=/usr/bin/lynx         \
#            --with-vgrind=/usr/bin/vgrind        \
#            --with-grap=/usr/bin/grap
#make
#make check
#make install
#cd ..
#rm -rf man-db-2.6.5
#
## 6.57
#cd /sources
#tar Jxf patch-2.7.1.tar.xz
#cd patch-2.7.1
#./configure --prefix=/usr --bindir=/bin
#make
#make check
#make install
#cd ..
#rm -rf patch-2.7.1
#
## 6.58
#cd /sources
#tar zxf sysklogd-1.5.tar.gz
#cd sysklogd-1.5
#make
#make BINDIR=/sbin install
#
#cat > /etc/syslog.conf << "EOF"
## Begin /etc/syslog.conf
#
#auth,authpriv.* -/var/log/auth.log
#*.*;auth,authpriv.none -/var/log/sys.log
#daemon.* -/var/log/daemon.log
#kern.* -/var/log/kern.log
#mail.* -/var/log/mail.log
#user.* -/var/log/user.log
#*.emerg *
#
## End /etc/syslog.conf
#EOF
#
#cd ..
#rm -rf sysklogd-1.5
#
## 6.59
#cd /sources
#tar jxf sysvinit-2.88dsf.tar.bz2
#cd sysvinit-2.88dsf
#sed -i 's@Sending processes@& configured via /etc/inittab@g' src/init.c
#sed -i -e '/utmpdump/d' \
#       -e '/mountpoint/d' src/Makefile
#make -C src
#make -C src install
#cd ..
#rm -rf sysvinit-2.88dsf
#
## 6.60
#cd /sources
#tar jxf tar-1.26.tar.bz2
#cd tar-1.26
#patch -Np1 -i ../tar-1.26-manpage-1.patch
#sed -i -e '/gets is a/d' gnu/stdio.in.h
#FORCE_UNSAFE_CONFIGURE=1  \
#./configure --prefix=/usr \
#            --bindir=/bin \
#            --libexecdir=/usr/sbin
#make
#make check
#make install
#make -C doc install-html docdir=/usr/share/doc/tar-1.26
#perl tarman > /usr/share/man/man1/tar.1
#cd ..
#rm -rf tar-1.26
#
## 6.61
#cd /sources
#tar Jxf texinfo-5.1.tar.xz
#cd texinfo-5.1
#patch -Np1 -i ../texinfo-5.1-test-1.patch
#./configure --prefix=/usr
#make
#make check
#make install
#make TEXMF=/usr/share/texmf install-tex
#cd ..
#rm -rf texinfo-5.1
#
## 6.62
#cd /sources
#tar Jxf systemd-206.tar.xz
#cd systemd-206
#tar -xvf ../udev-lfs-206-1.tar.bz2
#make -f udev-lfs-206-1/Makefile.lfs
#make -f udev-lfs-206-1/Makefile.lfs install
#build/udevadm hwdb --update
#bash udev-lfs-206-1/init-net-rules.sh
#cd ..
#rm -rf systemd-206

# 6.63
cd /sources
tar jxf vim-7.4.tar.bz2
cd vim74
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr --enable-multibyte
make
make test
make install

ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

cd ..
rm -rf vim74
