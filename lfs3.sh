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
cd /sources
tar Jxf glibc-2.18.tar.xz
cd glibc-2.18
sed -i -e 's/static __m128i/inline &/' sysdeps/x86_64/multiarch/strstr.c
mkdir -v ../glibc-build
cd ../glibc-build
../glibc-2.18/configure       \
  --prefix=/usr               \
  --disable-profile           \
  --enable-kernel=2.6.32      \
  --libexecdir=/usr/lib/glibc
make
make -k check 2>&1 | tee glibc-check-log
grep Error glibc-check-log
touch /etc/ld.so.conf
make install
cp -v ../glibc-2.18/sunrpc/rpc/*.h /usr/include/rpc
cp -v ../glibc-2.18/sunrpc/rpcsvc/*.h /usr/include/rpcsvc
cp -v ../glibc-2.18/nis/rpcsvc/*.h /usr/include/rpcsvc
mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030

# 6.9.2
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../tzdata2013d.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew solar87 solar88 solar89 \
          systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
