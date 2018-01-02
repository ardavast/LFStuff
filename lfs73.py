#!/usr/bin/env python3

import os
import platform
import subprocess
import tempfile

from contextlib import contextmanager

#cp -v --remove-destination /usr/share/zoneinfo/Europe/Sofia /etc/localtime
LFS = '/mnt/lfs'
LFS_TGT = '{0}-lfs-linux-gnu'.format(platform.machine())

partitions = (',512,,*\n'
              ',512,S\n'
              ';\n')

lfsenv = {
    'USER': 'lfs',
    'HOME': '/home/lfs',
    'LFS': LFS,
    'LC_ALL': 'POSIX',
    'LFS_TGT': LFS_TGT,
    'PATH': '/tools/bin:/bin:/usr/bin',
    'MAKEFLAGS': '-j4'
}

def shch(cmd, *args, **kwargs):
    #subprocess.check_call(['/tools/bin/sh', '-c', cmd] , *args, **kwargs)
    #subprocess.check_call(cmd, shell=True, executable='/tools/bin/sh', *args, **kwargs)
    subprocess.check_call(cmd, shell=True, *args, **kwargs)

def sh(cmd, *args, **kwargs):
    subprocess.check_call(['su', 'root', '-c', cmd], *args, **kwargs)

def shlfs(cmd, *args, **kwargs):
    subprocess.check_call(['su', 'lfs', '-c', cmd], env=lfsenv, *args, **kwargs)

from contextlib import contextmanager

@contextmanager
def cwd(path):
    wd = os.getcwd()
    os.chdir(path)
    try:
        yield
    finally:
        os.chdir(wd)

@contextmanager
def pkg(pkg, archive=None):
    if archive is None:
        archive = pkg

    wd = os.getcwd()

    try:
        if os.path.exists('{0}.tar.gz'.format(archive)):
            shch('tar zxf {0}.tar.gz'.format(archive))
        elif os.path.exists('{0}.tar.bz2'.format(archive)):
            shch('tar jxf {0}.tar.bz2'.format(archive))
        elif os.path.exists('{0}.tar.xz'.format(archive)):
            shch('tar Jxf {0}.tar.xz'.format(archive))

        os.chdir(pkg)

        yield

    finally:
        os.chdir(wd)
        shch('rm -rf {0}'.format(pkg))

# 2.2. Creating a New Partition
# http://www.linuxfromscratch.org/lfs/downloads/7.3/LFS-BOOK-7.3-NOCHUNKS.html#space-creatingpartition
# fd, pathname = tempfile.mkstemp(text=True)
# with open(pathname, 'w') as fp:
#     fp.write(partitions)
# with open(pathname, 'r') as fp:
#     sh('sfdisk /dev/sdb -uM', stdin=fp)
# os.close(fd)
# os.remove(pathname)

# 2.3. Creating a File System on the Partition
# http://www.linuxfromscratch.org/lfs/downloads/7.3/LFS-BOOK-7.3-NOCHUNKS.html#space-creatingfilesystem
# sh('mke2fs -jv /dev/sdb1')
# sh('mkswap /dev/sdb2')
# sh('mke2fs -jv /dev/sdb3')

# 2.4. Mounting the new partition
# http://www.linuxfromscratch.org/lfs/downloads/7.3/LFS-BOOK-7.3-NOCHUNKS.html#space-mounting
#sh('mkdir -v {0}'.format(LFS))
#sh('mount -v -t ext3 /dev/sdb3 {0}'.format(LFS))

#sh('mkdir -v {0}/boot'.format(LFS))
#sh('mount -v -t ext3 /dev/sdb1 {0}/boot'.format(LFS))

#sh('/sbin/swapon -v /dev/sdb2')

# 3. Packages and Patches
# 3.1. Introduction
#shroot('mkdir -v {0}/sources'.format(LFS))
#shroot('chmod -v a+wt {0}/sources'.format(LFS))
#shroot('wget -nc -i wget-lists/wget-list-7.3 -P {0}/sources'.format(LFS))
#with cwd('{0}/sources'.format(LFS)):
#    shroot('md5sum -c /root/LFStuff/md5sums/md5sums-7.3')

# 4.2.
#sh('mkdir -v {0}/tools'.format(LFS))
#sh('ln -sv {0}/tools /'.format(LFS))

# 4.3.
#sh('groupadd lfs')
#sh('useradd -s /bin/bash -g lfs -m -k /dev/null lfs')
#sh('chown -v lfs {0}/tools'.format(LFS))
#sh('chown -v lfs {0}/sources'.format(LFS))

# 4.4.
#with open('/home/lfs/.bash_profile', 'w') as fp:
#    fp.write(r"exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash" '\n')
#
#with open('/home/lfs/.bashrc', 'w') as fp:
#    fp.write('set +h\n'
#             'umask 022\n'
#             'LFS=/mnt/lfs\n'
#             'LC_ALL=POSIX\n'
#             'LFS_TGT=$(uname -m)-lfs-linux-gnu\n'
#             'PATH=/tools/bin:/bin:/usr/bin\n'
#             'export LFS LC_ALL LFS_TGT PATH\n')



os.umask(0o022)
os.chdir('{0}/sources'.format(LFS))

# 5.4. Binutils-2.23.1 - Pass 1
#with pkg('binutils-2.23.1'):
#    shlfs('mkdir -v ../binutils-build')
#    with cwd('../binutils-build'):
#        shlfs('../binutils-2.23.1/configure \
#            --prefix=/tools                 \
#            --with-sysroot=$LFS             \
#            --with-lib-path=/tools/lib      \
#            --target=$LFS_TGT               \
#            --disable-nls                   \
#            --disable-werror'))
#        shlfs('make')
#        shlfs('mkdir -v /tools/lib')
#        shlfs('ln -sv lib /tools/lib64')
#        shlfs('make install')
#    shlfs('rm -rf ../binutils-build')

# 5.5. GCC-4.7.2 - Pass 1
#with pkg('gcc-4.7.2'):
#    shlfs('tar -Jxf ../mpfr-3.1.1.tar.xz')
#    shlfs('mv -v mpfr-3.1.1 mpfr')
#    shlfs('tar -Jxf ../gmp-5.1.1.tar.xz')
#    shlfs('mv -v gmp-5.1.1 gmp')
#    shlfs('tar -zxf ../mpc-1.0.1.tar.gz')
#    shlfs('mv -v mpc-1.0.1 mpc')
#    for filename in [
#        'gcc/config/alpha/linux.h',
#        'gcc/config/bfin/linux.h',
#        'gcc/config/cris/linux.h',
#        'gcc/config/frv/linux.h',
#        'gcc/config/i386/linux.h',
#        'gcc/config/i386/linux64.h',
#        'gcc/config/i386/sysv4.h',
#        'gcc/config/ia64/linux.h',
#        'gcc/config/ia64/sysv4.h',
#        'gcc/config/linux.h',
#        'gcc/config/m32r/linux.h',
#        'gcc/config/m68k/linux.h',
#        'gcc/config/microblaze/linux.h',
#        'gcc/config/mips/linux.h',
#        'gcc/config/mips/linux64.h',
#        'gcc/config/mn10300/linux.h',
#        'gcc/config/rs6000/linux.h',
#        'gcc/config/rs6000/linux64.h',
#        'gcc/config/rs6000/sysv4.h',
#        'gcc/config/s390/linux.h',
#        'gcc/config/sh/linux.h',
#        'gcc/config/sparc/linux.h',
#        'gcc/config/sparc/linux64.h',
#        'gcc/config/sparc/sysv4.h',
#        'gcc/config/tilegx/linux.h',
#        'gcc/config/tilepro/linux.h',
#        'gcc/config/vax/linux.h',
#        'gcc/config/xtensa/linux.h',
#    ]:
#        shlfs('cp -uv {0} {0}.orig'.format(filename))
#        shlfs("sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g'               \
#                   -e 's@/usr@/tools@g' {0}.orig > {0}".format(filename))
#        with open(filename, 'a') as fp:
#            fp.write('\n'
#                     '#undef STANDARD_STARTFILE_PREFIX_1\n'
#                     '#undef STANDARD_STARTFILE_PREFIX_2\n'
#                     '#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"\n'
#                     '#define STANDARD_STARTFILE_PREFIX_2 ""\n')
#        shlfs('touch {0}.orig'.format(filename))
#    shlfs("sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure")
#    shlfs("sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure")
#    shlfs('mkdir -v ../gcc-build')
#    with cwd('../gcc-build'):
#        shlfs('../gcc-4.7.2/configure                               \
#                   --target=$LFS_TGT                                \
#                   --prefix=/tools                                  \
#                   --with-sysroot=$LFS                              \
#                   --with-newlib                                    \
#                   --without-headers                                \
#                   --with-local-prefix=/tools                       \
#                   --with-native-system-header-dir=/tools/include   \
#                   --disable-nls                                    \
#                   --disable-shared                                 \
#                   --disable-multilib                               \
#                   --disable-decimal-float                          \
#                   --disable-threads                                \
#                   --disable-libmudflap                             \
#                   --disable-libssp                                 \
#                   --disable-libgomp                                \
#                   --disable-libquadmath                            \
#                   --enable-languages=c                             \
#                   --with-mpfr-include=$(pwd)/../gcc-4.7.2/mpfr/src \
#                   --with-mpfr-lib=$(pwd)/mpfr/src/.libs')
#        shlfs('make')
#        shlfs('make install')
#        shlfs("ln -sv libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`")
#    shlfs('rm -rf ../gcc-build')

# 5.6. Linux-3.8.1 API Headers
#with pkg('linux-3.8.1'):
#    shlfs('make mrproper')
#    shlfs('make headers_check')
#    shlfs('make INSTALL_HDR_PATH=dest headers_install')
#    shlfs('cp -rv dest/include/* /tools/include')

# 5.7. Glibc-2.17
#with pkg('glibc-2.17'):
#    shlfs('mkdir -v ../glibc-build')
#    with cwd('../glibc-build'):
#        shlfs('../glibc-2.17/configure                           \
#                   --prefix=/tools                               \
#                   --host=$LFS_TGT                               \
#                   --build=$(../glibc-2.17/scripts/config.guess) \
#                   --disable-profile                             \
#                   --enable-kernel=2.6.25                        \
#                   --with-headers=/tools/include                 \
#                   libc_cv_forced_unwind=yes                     \
#                   libc_cv_ctors_header=yes                      \
#                   libc_cv_c_cleanup=yes')
#        shlfs('make')
#        shlfs('make install')
#    shlfs('rm -rf ../glibc-build')

# 5.8. Binutils-2.23.1 - Pass 2
#with pkg('binutils-2.23.1'):
#    shlfs('mkdir -v ../binutils-build')
#    with cwd('../binutils-build'):
#        shlfs('CC=$LFS_TGT-gcc                  \
#               AR=$LFS_TGT-ar                   \
#               RANLIB=$LFS_TGT-ranlib           \
#               ../binutils-2.23.1/configure     \
#                   --prefix=/tools              \
#                   --disable-nls                \
#                   --with-lib-path=/tools/lib')
#        shlfs('make')
#        shlfs('make install')
#        shlfs('make -C ld clean')
#        shlfs('make -C ld LIB_PATH=/usr/lib:/lib')
#        shlfs('cp -v ld/ld-new /tools/bin')
#    shlfs('rm -rf ../binutils-build')

# 5.9. GCC-4.7.2 - Pass 2
#with pkg('gcc-4.7.2'):
#    shlfs('cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
#           `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h')
#    shlfs('cp -v gcc/Makefile.in{,.tmp}')
#    shlfs("sed 's/^T_CFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in.tmp > gcc/Makefile.in")
#    for filename in [
#        'gcc/config/alpha/linux.h',
#        'gcc/config/bfin/linux.h',
#        'gcc/config/cris/linux.h',
#        'gcc/config/frv/linux.h',
#        'gcc/config/i386/linux.h',
#        'gcc/config/i386/linux64.h',
#        'gcc/config/i386/sysv4.h',
#        'gcc/config/ia64/linux.h',
#        'gcc/config/ia64/sysv4.h',
#        'gcc/config/linux.h',
#        'gcc/config/m32r/linux.h',
#        'gcc/config/m68k/linux.h',
#        'gcc/config/microblaze/linux.h',
#        'gcc/config/mips/linux.h',
#        'gcc/config/mips/linux64.h',
#        'gcc/config/mn10300/linux.h',
#        'gcc/config/rs6000/linux.h',
#        'gcc/config/rs6000/linux64.h',
#        'gcc/config/rs6000/sysv4.h',
#        'gcc/config/s390/linux.h',
#        'gcc/config/sh/linux.h',
#        'gcc/config/sparc/linux.h',
#        'gcc/config/sparc/linux64.h',
#        'gcc/config/sparc/sysv4.h',
#        'gcc/config/tilegx/linux.h',
#        'gcc/config/tilepro/linux.h',
#        'gcc/config/vax/linux.h',
#        'gcc/config/xtensa/linux.h',
#    ]:
#        shlfs('cp -uv {0} {0}.orig'.format(filename))
#        shlfs("sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g'               \
#                   -e 's@/usr@/tools@g' {0}.orig > {0}".format(filename))
#        with open(filename, 'a') as fp:
#            fp.write('\n'
#                     '#undef STANDARD_STARTFILE_PREFIX_1\n'
#                     '#undef STANDARD_STARTFILE_PREFIX_2\n'
#                     '#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"\n'
#                     '#define STANDARD_STARTFILE_PREFIX_2 ""\n')
#        shlfs('touch {0}.orig'.format(filename))
#    shlfs('tar -Jxf ../mpfr-3.1.1.tar.xz')
#    shlfs('mv -v mpfr-3.1.1 mpfr')
#    shlfs('tar -Jxf ../gmp-5.1.1.tar.xz')
#    shlfs('mv -v gmp-5.1.1 gmp')
#    shlfs('tar -zxf ../mpc-1.0.1.tar.gz')
#    shlfs('mv -v mpc-1.0.1 mpc')
#    shlfs("sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure")
#    shlfs('mkdir -v ../gcc-build')
#    with cwd('../gcc-build'):
#        shlfs('CC=$LFS_TGT-gcc                                      \
#               AR=$LFS_TGT-ar                                       \
#               RANLIB=$LFS_TGT-ranlib                               \
#               ../gcc-4.7.2/configure                               \
#                   --prefix=/tools                                  \
#                   --with-local-prefix=/tools                       \
#                   --with-native-system-header-dir=/tools/include   \
#                   --enable-clocale=gnu                             \
#                   --enable-shared                                  \
#                   --enable-threads=posix                           \
#                   --enable-__cxa_atexit                            \
#                   --enable-languages=c,c++                         \
#                   --disable-libstdcxx-pch                          \
#                   --disable-multilib                               \
#                   --disable-bootstrap                              \
#                   --disable-libgomp                                \
#                   --with-mpfr-include=$(pwd)/../gcc-4.7.2/mpfr/src \
#                   --with-mpfr-lib=$(pwd)/mpfr/src/.libs')
#        shlfs('make')
#        shlfs('make install')
#        shlfs('ln -sv gcc /tools/bin/cc')
#    shlfs('rm -rf ../gcc-build')

#5.10 Tcl-8.6.0
#with pkg('tcl8.6.0', 'tcl8.6.0-src'):
#    with cwd('unix'):
#        shlfs('./configure --prefix=/tools')
#        shlfs('make')
#        shlfs('TZ=UTC make test')
#        shlfs('make install')
#        shlfs('chmod -v u+w /tools/lib/libtcl8.6.so')
#        shlfs('make install-private-headers')
#        shlfs('ln -sv tclsh8.6 /tools/bin/tclsh')

##5.11 Expect-5.45
#with pkg('expect5.45'):
#    shlfs('cp -v configure{,.orig}')
#    shlfs("sed 's:/usr/local/bin:/bin:' configure.orig > configure")
#    shlfs('./configure                            \
#               --prefix=/tools                    \
#               --with-tcl=/tools/lib              \
#               --with-tclinclude=/tools/include')
#    shlfs('make')
#    shlfs('make test')
#    shlfs('make SCRIPTS="" install')

#5.12 DejaGNU-1.5
#with pkg('dejagnu-1.5'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make install')
#    shlfs('make check')

#5.13 Check-0.9.9
#with pkg('check-0.9.9'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make check')
#    shlfs('make')
#    shlfs('make install')

#5.14 Ncurses-5.9
#with pkg('ncurses-5.9'):
#    shlfs('./configure              \
#               --prefix=/tools      \
#               --with-shared        \
#               --without-debug      \
#               --without-ada        \
#               --enable-overwrite')
#    shlfs('make')
#    shlfs('make install')

#5.15 Bash-4.2
#with pkg('bash-4.2'):
#    shlfs('patch -Np1 -i ../bash-4.2-fixes-11.patch')
#    shlfs('./configure                 \
#               --prefix=/tools         \
#               --without-bash-malloc')
#    shlfs('make')
#    shlfs('make tests')
#    shlfs('make install')
#    shlfs('ln -sv bash /tools/bin/sh')

#5.16 Bzip2-1.0.6
#with pkg('bzip2-1.0.6'):
#    shlfs('make')
#    shlfs('make PREFIX=/tools install')

#5.17 Coreutils-8.21
#with pkg('coreutils-8.21'):
#    shlfs('./configure                             \
#               --prefix=/tools                     \
#               --enable-install-program=hostname')
#    shlfs('make')
#    #shlfs('make RUN_EXPENSIVE_TESTS=yes check') #FIXME
#    shlfs('make install')

#5.18 Diffutils-3.2
#with pkg('diffutils-3.2'):
#    shlfs("sed -i -e '/gets is a/d' lib/stdio.in.h")
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.19 File-5.13
#with pkg('file-5.13'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.20 Findutils-4.4.2
#with pkg('findutils-4.4.2'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.21 Gawk-4.0.2
#with pkg('gawk-4.0.2'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.22 Gettext-0.18.2
#with pkg('gettext-0.18.2'):
#    with cwd('gettext-tools'):
#        shlfs('EMACS="no"             \
#               ./configure            \
#                   --prefix=/tools    \
#                   --disable-shared')
#        shlfs('make -C gnulib-lib')
#        shlfs('make -C src msgfmt')
#        shlfs('cp -v src/msgfmt /tools/bin')

#5.23 Grep-2.14
#with pkg('grep-2.14'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.24 Gzip-1.5
#with pkg('gzip-1.5'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.25 M4-1.4.16
#with pkg('m4-1.4.16'):
#    shlfs("sed -i -e '/gets is a/d' lib/stdio.in.h")
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.26 Make-3.82
#with pkg('make-3.82'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.27 Patch-2.7.1
#with pkg('patch-2.7.1'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.28 Perl-5.16.2
#with pkg('perl-5.16.2'):
#    shlfs('patch -Np1 -i ../perl-5.16.2-libc-1.patch')
#    shlfs('sh Configure -des -Dprefix=/tools')
#    shlfs('make')
#    shlfs('cp -v perl cpan/podlators/pod2man /tools/bin')
#    shlfs('mkdir -pv /tools/lib/perl5/5.16.2')
#    shlfs('cp -Rv lib/* /tools/lib/perl5/5.16.2')

#5.29 Sed-4.2.2
#with pkg('sed-4.2.2'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.30 Tar-1.26
#with pkg('tar-1.26'):
#    shlfs("sed -i -e '/gets is a/d' gnu/stdio.in.h")
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.31 Texinfo-5.0
#with pkg('texinfo-5.0'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

#5.32 Xz-5.0.4
#with pkg('xz-5.0.4'):
#    shlfs('./configure --prefix=/tools')
#    shlfs('make')
#    shlfs('make check')
#    shlfs('make install')

os.environ['LFS'] = LFS
os.chdir('{0}'.format(LFS))
# 6.2. Preparing Virtual Kernel File Systems
#sh('mkdir -v $LFS/{dev,proc,sys}')

# 6.2.1. Creating Initial Device Nodes
#sh('mknod -m 600 $LFS/dev/console c 5 1')
#sh('mknod -m 666 $LFS/dev/null c 1 3')

# 6.2.2. Mounting and Populating /dev
#sh('mount -v --bind /dev $LFS/dev')

# 6.2.3. Mounting Virtual Kernel File Systems
#sh('mount -vt devpts devpts $LFS/dev/pts')
#sh('mount -vt proc proc $LFS/proc')
#sh('mount -vt sysfs sysfs $LFS/sys')

#shmpath = '{0}/dev/shm'.format(LFS)
#if os.path.islink(shmpath):
#    shmlink = os.readlink(shmpath)
#    sh('mkdir -p $LFS/{0}'.format(shmlink))
#    sh('mount -vt tmpfs shm $LFS/{0}'.format(shmlink))
#else:
#    sh('mount -vt tmpfs shm {0}'.format(shmpath))

# 6.4. Entering the Chroot Environment
os.chroot(LFS)
TERM = os.environ['TERM']
os.environ.clear()
os.environ['HOME'] = '/root'
os.environ['TERM'] = TERM
os.environ['PS1'] = r'\u:\w\$ '
os.environ['PATH'] = '/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin'

# 6.5. Creating Directories
#shch('mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt,run}')
#shch('mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}')
#shch('install -dv -m 0750 /root')
#shch('install -dv -m 1777 /tmp /var/tmp')
#shch('mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}')
#shch('mkdir -pv /usr/{,local/}share/{doc,info,locale,man}')
#shch('mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}')
#shch('mkdir -pv /usr/{,local/}share/man/man{1..8}')
#shch('ln -sv share/{man,doc,info} /usr')
#shch('ln -sv share/{man,doc,info} /usr/local')
#shch('ln -sv lib /lib64 ')
#shch('ln -sv lib /usr/lib64')
#shch('mkdir -v /var/{log,mail,spool}')
#shch('ln -sv /run /var/run')
#shch('ln -sv /run/lock /var/lock')
#shch('mkdir -pv /var/{opt,cache,lib/{misc,locate},local}')

# 6.6. Creating Essential Files and Symlinks
#shch('ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin')
#shch('ln -sv /tools/bin/perl /usr/bin')
#shch('ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib')
#shch('ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib')
#shch("sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la")
#shch('ln -sv bash /bin/sh')
#shch('touch /etc/mtab')
#with open('/etc/passwd', 'w') as fp:
#    fp.write('root:x:0:0:root:/root:/bin/bash\n'
#             'bin:x:1:1:bin:/dev/null:/bin/false\n'
#             'nobody:x:99:99:Unprivileged User:/dev/null:/bin/false\n')
#with open('/etc/group', 'w') as fp:
#    fp.write('root:x:0:\n'
#             'bin:x:1:\n'
#             'sys:x:2:\n'
#             'kmem:x:3:\n'
#             'tape:x:4:\n'
#             'tty:x:5:\n'
#             'daemon:x:6:\n'
#             'floppy:x:7:\n'
#             'disk:x:8:\n'
#             'lp:x:9:\n'
#             'dialout:x:10:\n'
#             'audio:x:11:\n'
#             'video:x:12:\n'
#             'utmp:x:13:\n'
#             'usb:x:14:\n'
#             'cdrom:x:15:\n'
#             'mail:x:34:\n'
#             'nogroup:x:99:\n')
#shch('touch /var/log/{btmp,lastlog,wtmp}')
#shch('chgrp -v utmp /var/log/lastlog')
#shch('chmod -v 664  /var/log/lastlog')
#shch('chmod -v 600  /var/log/btmp')

os.chdir('/sources')
## 6.7. Linux-3.8.1 API Headers
#with pkg('linux-3.8.1'):
#    shch('make mrproper')
#    shch('make headers_check')
#    shch('make INSTALL_HDR_PATH=dest headers_install')
#    shch('find dest/include \\( -name .install -o -name ..install.cmd \\) -delete')
#    shch('cp -rv dest/include/* /usr/include')

## 6.8. Man-pages-3.47
#with pkg('man-pages-3.47'):
#    shch('make install')

## 6.9. Glibc-2.17
#with pkg('glibc-2.17'):
#    shch('mkdir -v ../glibc-build')
#    with cwd('../glibc-build'):
#        shch('../glibc-2.17/configure           \
#                  --prefix=/usr                 \
#                  --disable-profile             \
#                  --enable-kernel=2.6.25        \
#                  --libexecdir=/usr/lib/glibc')
#        shch('make')
#        shch('make -k check') #FIXME
#        shch('touch /etc/ld.so.conf')
#        shch('make install')
#        shch('cp -v ../glibc-2.17/sunrpc/rpc/*.h /usr/include/rpc')
#        shch('cp -v ../glibc-2.17/sunrpc/rpcsvc/*.h /usr/include/rpcsvc')
#        shch('cp -v ../glibc-2.17/nis/rpcsvc/*.h /usr/include/rpcsvc')
#        shch('make localedata/install-locales') #FIXME
#
#        with open('/etc/nsswitch.conf', 'w') as fp:
#            fp.write('passwd: files\n'
#                     'group: files\n'
#                     'shadow: files\n'
#                     '\n'
#                     'hosts: files dns\n'
#                     'networks: files\n'
#                     '\n'
#                     'protocols: files\n'
#                     'services: files\n'
#                     'ethers: files\n'
#                     'rpc: files\n'
#                     '\n'
#                     '# End /etc/nsswitch.conf\n')
#
#        shch('tar -xf ../tzdata2012j.tar.gz')
#
#        shch('mkdir -pv /usr/share/zoneinfo/posix')
#        shch('mkdir -pv /usr/share/zoneinfo/right')
#
#        for tz in ['etcetera', 'southamerica','northamerica', 'europe',
#                   'africa', 'antarctica', 'asia', 'australasia', 'backward',
#                   'pacificnew', 'solar87', 'solar88', 'solar89', 'systemv']:
#            shch('zic -L /dev/null   -d /usr/share/zoneinfo       -y "sh yearistype.sh" {0}'.format(tz))
#            shch('zic -L /dev/null   -d /usr/share/zoneinfo/posix -y "sh yearistype.sh" {0}'.format(tz))
#            shch('zic -L leapseconds -d /usr/share/zoneinfo/right -y "sh yearistype.sh" {0}'.format(tz))
#
#        shch('cp -v zone.tab iso3166.tab /usr/share/zoneinfo')
#        shch('zic -d /usr/share/zoneinfo -p America/New_York')
#        shch('cp -v --remove-destination /usr/share/zoneinfo/UTC /etc/localtime')
#
#    with open('/etc/ld.so.conf', 'w') as fp:
#        fp.write('# Begin /etc/ld.so.conf\n'
#             '/usr/local/lib\n'
#             '/opt/lib\n'
#             '\n'
#             '# Add an include directory\n'
#             'include /etc/ld.so.conf.d/*.conf\n')
#    shch('mkdir /etc/ld.so.conf.d')
#    shch('rm -rf ../glibc-build')

## 6.10. Adjusting the Toolchain
#shch('mv -v /tools/bin/{ld,ld-old}')
#shch('mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}')
#shch('mv -v /tools/bin/{ld-new,ld}')
#shch('ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld')
#shch("gcc -dumpspecs |                                    \
#      sed -e 's@/tools@@g'                                \
#      -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
#      -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
#      `dirname $(gcc --print-libgcc-file-name)`/specs")
#      # FIXME: add verification

## 6.11. Zlib-1.2.7
#with pkg('zlib-1.2.7'):
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')
#    shch('mv -v /usr/lib/libz.so.* /lib')
#    shch('ln -sfv ../../lib/libz.so.1.2.7 /usr/lib/libz.so')

## 6.12. File-5.13
#with pkg('file-5.13'):
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.13. Binutils-2.23.1
#with pkg('binutils-2.23.1'):
#    shch('rm -fv etc/standards.info')
#    shch("sed -i.bak '/^INFO/s/standards.info //' etc/Makefile.in")
#    shch('patch -Np1 -i ../binutils-2.23.1-testsuite_fix-1.patch')
#    shch('mkdir -v ../binutils-build')
#    with cwd('../binutils-build'): # FIXME enable-lto
#        shch('../binutils-2.23.1/configure \
#                  --prefix=/usr            \
#                  --enable-shared')
#        shch('make tooldir=/usr')
#        shch('make check')
#        shch('make tooldir=/usr install')
#        shch('cp -v ../binutils-2.23.1/include/libiberty.h /usr/include')
#    shch('rm -rf ../binutils-build')

## 6.14. GMP-5.1.1
#with pkg('gmp-5.1.1'):
#    shch('./configure       \
#             --prefix=/usr  \
#             --enable-cxx')
#    shch('make')
#    shch('make check') # FIXME
#    shch('make install')
#    shch('mkdir -v /usr/share/doc/gmp-5.1.1')
#    shch('cp -v doc/{isa_abi_headache,configuration} doc/*.html /usr/share/doc/gmp-5.1.1')

## 6.15. MPFR-3.1.1
#with pkg('mpfr-3.1.1'):
#    shch('./configure                              \
#              --prefix=/usr                        \
#              --enable-thread-safe                 \
#              --docdir=/usr/share/doc/mpfr-3.1.1')
#    shch('make')
#    shch('make check')
#    shch('make install')
#    shch('make html')
#    shch('make install-html')

## 6.16. MPC-1.0.1
#with pkg('mpc-1.0.1'):
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.17. GCC-4.7.2
#with pkg('gcc-4.7.2'):
#    shch("sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in")
#    shch("sed -i 's/BUILD_INFO=info/BUILD_INFO=/' gcc/configure")
#    shch("sed -i -e /autogen/d -e /check.sh/d fixincludes/Makefile.in")
#    shch('mkdir -v ../gcc-build')
#    with cwd('../gcc-build'):
#        shch('../gcc-4.7.2/configure       \
#                  --prefix=/usr            \
#                  --libexecdir=/usr/lib    \
#                  --enable-shared          \
#                  --enable-threads=posix   \
#                  --enable-__cxa_atexit    \
#                  --enable-clocale=gnu     \
#                  --enable-languages=c,c++ \
#                  --disable-multilib       \
#                  --disable-bootstrap      \
#                  --with-system-zlib')
#        shch('make')
#        #ulimit -s 32768 FIXME
#        #shch('make -k check')
#        shch('make install')
#        shch('ln -sv ../usr/bin/cpp /lib')
#        shch('ln -sv gcc /usr/bin/cc')
#        shch('mkdir -pv /usr/share/gdb/auto-load/usr/lib')
#        shch('mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib')

## 6.18. Sed-4.2.2
#with pkg('sed-4.2.2'):
#    shch('./configure                              \
#              --prefix=/usr                        \
#              --bindir=/bin                        \
#              --htmldir=/usr/share/doc/sed-4.2.2')
#    shch('make')
#    shch('make html')
#    shch('make check')
#    shch('make install')
#    shch('make -C doc install-html')

## 6.19. Bzip2-1.0.6
#with pkg('bzip2-1.0.6'):
#    shch('patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch')
#    shch(r"sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile")
#    shch(r"sed -i 's@(PREFIX)/man@(PREFIX)/share/man@g' Makefile")
#    shch('make -f Makefile-libbz2_so')
#    shch('make clean')
#    shch('make')
#    shch('make PREFIX=/usr install')
#    shch('cp -v bzip2-shared /bin/bzip2')
#    shch('cp -av libbz2.so* /lib')
#    shch('ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so')
#    shch('rm -v /usr/bin/{bunzip2,bzcat,bzip2}')
#    shch('ln -sv bzip2 /bin/bunzip2')
#    shch('ln -sv bzip2 /bin/bzcat')

## 6.20. Pkg-config-0.28
#with pkg('pkg-config-0.28'):
#    shch('./configure                                     \
#                --prefix=/usr                             \
#                --with-internal-glib                      \
#                --disable-host-tool                       \
#                --docdir=/usr/share/doc/pkg-config-0.28')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.21. Ncurses-5.9
#with pkg('ncurses-5.9'):
#    shch('./configure                 \
#              --prefix=/usr           \
#              --mandir=/usr/share/man \
#              --with-shared           \
#              --without-debug         \
#              --enable-pc-files       \
#              --enable-widec')
#    shch('make')
#    shch('make install')
#    shch('mv -v /usr/lib/libncursesw.so.5* /lib')
#    shch('ln -sfv ../../lib/libncursesw.so.5 /usr/lib/libncursesw.so')
#    for lib in ['ncurses', 'form', 'panel', 'menu']:
#        shch('rm -vf                 /usr/lib/lib{0}.so'.format(lib))
#        shch('echo "INPUT(-l{0}w)" > /usr/lib/lib{0}.so'.format(lib))
#        shch('ln -sfv lib{0}w.a      /usr/lib/lib{0}.a'.format(lib))
#        shch('ln -sfv {0}w.pc        /usr/lib/pkgconfig/{0}.pc'.format(lib))
#    shch('ln -sfv libncurses++w.a /usr/lib/libncurses++.a')
#    shch('rm -vf                     /usr/lib/libcursesw.so')
#    shch('echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so')
#    shch('ln -sfv libncurses.so      /usr/lib/libcurses.so')
#    shch('ln -sfv libncursesw.a      /usr/lib/libcursesw.a')
#    shch('ln -sfv libncurses.a       /usr/lib/libcurses.a')
#    shch('mkdir -v       /usr/share/doc/ncurses-5.9')
#    shch('cp -v -R doc/* /usr/share/doc/ncurses-5.9')

## 6.22. Util-linux-2.22.2
#with pkg('util-linux-2.22.2'):
#    shch("sed -i -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' $(grep -rl '/etc/adjtime' .)")
#    shch('mkdir -pv /var/lib/hwclock')
#    shch('./configure           \
#              --disable-su      \
#              --disable-sulogin \
#              --disable-login') 
#    shch('make')
#    shch('make install')

## 6.23. Psmisc-22.20
#with pkg('psmisc-22.20'):
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make install')
#    shch('mv -v /usr/bin/fuser   /bin')
#    shch('mv -v /usr/bin/killall /bin')

## 6.24. Procps-ng-3.3.6
#with pkg('procps-ng-3.3.6'):
#    shch('./configure                                 \
#              --prefix=/usr                           \
#              --exec-prefix=                          \
#              --libdir=/usr/lib                       \
#              --docdir=/usr/share/doc/procps-ng-3.3.6 \
#              --disable-static                        \
#              --disable-skill                         \
#              --disable-kill')
#    shch('make')
#    #with cwd('testsuite'): # FIXME
#    #    shch(r"sed -i -e 's|exec which sleep|exec echo /tools/bin/sleep|'       \
#    #                  -e 's|999999|&9|' config/unix.exp")
#    #    shch(r"sed -i -e 's|pmap_initname\\\$|pmap_initname|' pmap.test/pmap.exp")
#    #    shch('make site.exp')
#    #    shch('DEJAGNU=global-conf.exp runtest')
#    shch('make install')
#    shch('mv -v /usr/lib/libprocps.so.* /lib')
#    shch('ln -sfv ../../lib/libprocps.so.1.1.0 /usr/lib/libprocps.so')

## 6.25. E2fsprogs-1.42.7
#with pkg('e2fsprogs-1.42.7'):
#    shch('mkdir -v build')
#    with cwd('build'):
#        shch('../configure              \
#                  --prefix=/usr         \
#                  --with-root-prefix="" \
#                  --enable-elf-shlibs   \
#                  --disable-libblkid    \
#                  --disable-libuuid     \
#                  --disable-uuidd       \
#                  --disable-fsck')
#        shch('make')
#        shch('make check')
#        shch('make install')
#        shch('make install-libs')
#        shch('chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a')
#        shch('gunzip -v /usr/share/info/libext2fs.info.gz')
#        shch('install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info')
#        shch('makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo')
#        shch('install -v -m644 doc/com_err.info /usr/share/info')
#        shch('install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info')
#    shch('rm -rf build')

## 6.26. Shadow-4.1.5.1
#with pkg('shadow-4.1.5.1'):
#    shch("sed -i 's/groups$(EXEEXT) //' src/Makefile.in")
#    shch("find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;")
#    shch("sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@'  \
#                 -e 's@/var/spool/mail@/var/mail@' etc/login.defs")
#    shch(r"sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs")
#    shch('./configure --sysconfdir=/etc')
#    shch('make')
#    shch('make install')
#    shch('mv -v /usr/bin/passwd /bin')
#    shch('pwconv')
#    shch('grpconv')
#    shch('echo "root:root" | chpasswd')

## 6.27. Coreutils-8.21
#with pkg('coreutils-8.21'):
#    shch('patch -Np1 -i ../coreutils-8.21-i18n-1.patch')
#    shch('FORCE_UNSAFE_CONFIGURE=1                      \
#          ./configure                                   \
#              --prefix=/usr                             \
#              --libexecdir=/usr/lib                     \
#              --enable-no-install-program=kill,uptime')
#    shch('make')
#    shch('make NON_ROOT_USERNAME=nobody check-root')
#    shch('echo "dummy:x:1000:nobody" >> /etc/group')
#    shch('chown -Rv nobody . ')
#    #shch('su nobody -s /bin/bash -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"')
#    shch("sed -i '/dummy/d' /etc/group")
#    shch('make install')
#    shch('mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin')
#    shch('mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin')
#    shch('mv -v /usr/bin/{rmdir,stty,sync,true,uname,test,[} /bin')
#    shch('mv -v /usr/bin/chroot /usr/sbin')
#    shch('mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8')
#    shch(r'sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8')
#    shch('mv -v /usr/bin/{head,sleep,nice} /bin')

## 6.28. Iana-Etc-2.30
#with pkg('iana-etc-2.30'):
#    shch('make')
#    shch('make install')

## 6.29. M4-1.4.16
#with pkg('m4-1.4.16'):
#    shch("sed -i -e '/gets is a/d' lib/stdio.in.h")
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch("sed -i -e '41s/ENOENT/& || errno == EINVAL/' tests/test-readlink.h")
#    shch('make check')
#    shch('make install')

## 6.30. Bison-2.7
#with pkg('bison-2.7'):
#    shch('./configure --prefix=/usr')
#    shch("echo '#define YYENABLE_NLS 1' >> lib/config.h")
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.31. Grep-2.14
#with pkg('grep-2.14'):
#    shch('./configure --prefix=/usr --bindir=/bin')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.32. Readline-6.2
#with pkg('readline-6.2'):
#    shch("sed -i '/MV.*old/d' Makefile.in")
#    shch("sed -i '/{OLDSUFF}/c:' support/shlib-install")
#    shch('patch -Np1 -i ../readline-6.2-fixes-1.patch')
#    shch('./configure --prefix=/usr --libdir=/lib')
#    shch('make SHLIB_LIBS=-lncurses')
#    shch('SHLIB_LIBS=-lncurses')
#    shch('make install')
#    shch('mv -v /lib/lib{readline,history}.a /usr/lib')
#    shch('rm -v /lib/lib{readline,history}.so')
#    shch('ln -sfv ../../lib/libreadline.so.6 /usr/lib/libreadline.so')
#    shch('ln -sfv ../../lib/libhistory.so.6 /usr/lib/libhistory.so')
#    shch('mkdir   -v                               /usr/share/doc/readline-6.2')
#    shch('install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.2')

## 6.33. Bash-4.2
##FIXME SWITCH TO BASH
#with pkg('bash-4.2'):
#    shch('patch -Np1 -i ../bash-4.2-fixes-11.patch')
#    shch('./configure --prefix=/usr             \
#              --bindir=/bin                     \
#              --htmldir=/usr/share/doc/bash-4.2 \
#              --without-bash-malloc             \
#              --with-installed-readline')
#    shch('make')
#    shch('chown -Rv nobody .')
#    shch('su nobody -s /bin/bash -c "PATH=$PATH make tests"')
#    shch('make install')

## 6.34. Libtool-2.4.2
#with pkg('libtool-2.4.2'):
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.35. GDBM-1.10
#with pkg('gdbm-1.10'):
#    shch('./configure                   \
#              --prefix=/usr             \
#              --enable-libgdbm-compat')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.36. Inetutils-1.9.1
#with pkg('inetutils-1.9.1'):
#    shch("sed -i -e '/gets is a/d' lib/stdio.in.h")
#    shch('./configure                \
#              --prefix=/usr          \
#              --libexecdir=/usr/sbin \
#              --localstatedir=/var   \
#              --disable-ifconfig     \
#              --disable-logger       \
#              --disable-syslogd      \
#              --disable-whois        \
#              --disable-servers')
#    shch('make')
#    shch('make check')
#    shch('make install')
#    shch('mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin')
    
## 6.37. Perl-5.16.2
#with pkg('perl-5.16.2'):
#    shch('echo "127.0.0.1 localhost $(hostname)" > /etc/hosts')
#    shch('sed -i -e "s|BUILD_ZLIB\s*= True|BUILD_ZLIB = False|"           \
#                 -e "s|INCLUDE\s*= ./zlib-src|INCLUDE    = /usr/include|" \
#                 -e "s|LIB\s*= ./zlib-src|LIB        = /usr/lib|"         \
#              cpan/Compress-Raw-Zlib/config.in')
#    shch('sh Configure -des -Dprefix=/usr           \
#                      -Dvendorprefix=/usr           \
#                      -Dman1dir=/usr/share/man/man1 \
#                      -Dman3dir=/usr/share/man/man3 \
#                      -Dpager="/usr/bin/less -isR"  \
#                      -Duseshrplib')
#    shch('make')
#    #shch('make -k test') #FIXME
#    shch('make install')

## 6.38. Autoconf-2.69
#with pkg('autoconf-2.69'):
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')
#
## 6.39. Automake-1.13.1
#with pkg('automake-1.13.1'):
#    shch('./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.13.1')
#    shch('make')
##    shch('make check')
#    shch('make install')
#
## 6.40. Diffutils-3.2
#with pkg('diffutils-3.2'):
#    shch("sed -i -e '/gets is a/d' lib/stdio.in.h")
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')
#
## 6.41. Gawk-4.0.2
#with pkg('gawk-4.0.2'):
#    shch('./configure --prefix=/usr --libexecdir=/usr/lib')
#    shch('make')
#    shch('make check')
#    shch('make install')
#    shch('mkdir -v /usr/share/doc/gawk-4.0.2')
#    shch('cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.0.2')
#
## 6.42. Findutils-4.4.2
#with pkg('findutils-4.4.2'):
#    shch('./configure                          \
#              --prefix=/usr                    \
#              --libexecdir=/usr/lib/findutils  \
#              --localstatedir=/var/lib/locate')
#    shch('make')
#    shch('make check')
#    shch('make install')
#    shch('mv -v /usr/bin/find /bin')
#    shch("sed -i 's/find:=${BINDIR}/find:=\/bin/' /usr/bin/updatedb")

## 6.43. Flex-2.5.37
#with pkg('flex-2.5.37'):
#    shch('patch -Np1 -i ../flex-2.5.37-bison-2.6.1-1.patch')
#    shch('./configure                               \
#              --prefix=/usr                         \
#              --docdir=/usr/share/doc/flex-2.5.37')
#    shch('make')
#    shch('make check')
#    shch('make install')
#    shch('ln -sv libfl.a /usr/lib/libl.a')
#    with open('/usr/bin/lex', 'w') as fp:
#        fp.write('#!/bin/sh\n'
#                 '# Begin /usr/bin/lex\n'
#                 '\n'
#                 'exec /usr/bin/flex -l "$@"\n'
#                 '\n'
#                 '# End /usr/bin/lex\n')
#    shch('chmod -v 755 /usr/bin/lex')

## 6.44. Gettext-0.18.2
#with pkg('gettext-0.18.2'):
#    shch('./configure                                  \
#              --prefix=/usr                            \
#              --docdir=/usr/share/doc/gettext-0.18.2')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.45. Groff-1.22.2
#with pkg('groff-1.22.2'):
#    paper_size = 'A4' # FIXME
#    shch('PAGE={0}            \
#          ./configure         \
#              --prefix=/usr'.format(paper_size))
#    shch('make')
#    shch('mkdir -p /usr/share/doc/groff-1.22/pdf')
#    shch('make install')
#    shch('ln -sv eqn /usr/bin/geqn')
#    shch('ln -sv tbl /usr/bin/gtbl')

## 6.46. Xz-5.0.4
#with pkg('xz-5.0.4'):
#    shch('./configure                            \
#              --prefix=/usr                      \
#              --libdir=/lib                      \
#              --docdir=/usr/share/doc/xz-5.0.4')
#    shch('make')
#    shch('make check')
#    shch('make pkgconfigdir=/usr/lib/pkgconfig install')

## 6.47. GRUB-2.00
#with pkg('GRUB-2.00'):
#    shch("sed -i -e '/gets is a/d' grub-core/gnulib/stdio.in.h")
#    shch('./configure                  \
#                --prefix=/usr          \
#                --sysconfdir=/etc      \
#                --disable-grub-emu-usb \
#                --disable-efiemu       \
#                --disable-werror')
#    shch('make')
#    shch('make install')

## 6.48. Less-451
#with pkg('less-451'):
#    shch('./configure             \
#              --prefix=/usr       \
#              --sysconfdir=/etc')
#    shch('make')
#    shch('make install')

## 6.49. Gzip-1.5
#with pkg('gzip-1.5'):
#    shch('./configure         \
#              --prefix=/usr   \
#              --bindir=/bin')
#    shch('make')
#    shch('make install')
#    shch('mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin')
#    shch('mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin')

## 6.50. IPRoute2-3.8.0
#with pkg('iproute2-3.8.0'):
#    shch(r"sed -i '/^TARGETS/s@arpd@@g' misc/Makefile")
#    shch(r'sed -i /ARPD/d Makefile')
#    shch(r"sed -i 's/arpd.8//' man/man8/Makefile")
#    shch(r"sed -i 's/-Werror//' Makefile")
#    shch('make DESTDIR=')
#    shch('make DESTDIR=                                  \
#          MANDIR=/usr/share/man                          \
#          DOCDIR=/usr/share/doc/iproute2-3.8.0 install')

## 6.51. Kbd-1.15.5
#with pkg('kbd-1.15.5'):
#    shch('patch -Np1 -i ../kbd-1.15.5-backspace-1.patch')
#    shch("sed -i -e '326 s/if/while/' src/loadkeys.analyze.l")
#    shch("sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure")
#    shch("sed -i 's/resizecons.8 //' man/man8/Makefile.in")
#    shch('./configure            \
#              --prefix=/usr      \
#              --datadir=/lib/kbd \
#              --disable-vlock')
#    shch('make')
#    shch('make install')

## 6.52. Kmod-12
#with pkg('kmod-12'):
#    shch('./configure               \
#              --prefix=/usr         \
#              --bindir=/bin         \
#              --libdir=/lib         \
#              --sysconfdir=/etc     \
#              --disable-manpages    \
#              --with-xz             \
#              --with-zlib')
#    shch('make')
#    shch('make check')
#    shch('make pkgconfigdir=/usr/lib/pkgconfig install')
#    for target in ['depmod', 'insmod', 'modinfo', 'modprobe', 'rmmod']:
#        shch('ln -sv ../bin/kmod /sbin/{0}'.format(target))
#    shch('ln -sv kmod /bin/lsmod')

## 6.53. Libpipeline-1.2.2
#with pkg('libpipeline-1.2.2'):
#    shch('PKG_CONFIG_PATH=/tools/lib/pkgconfig \
#          ./configure                          \
#              --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.54. Make-3.82
#with pkg('make-3.82'):
#    shch('patch -Np1 -i ../make-3.82-upstream_fixes-3.patch')
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.55. Man-DB-2.6.3
#with pkg('man-db-2.6.3'):
#    shch('./configure                                \
#              --prefix=/usr                          \
#              --libexecdir=/usr/lib                  \
#              --docdir=/usr/share/doc/man-db-2.6.3   \
#              --sysconfdir=/etc                      \
#              --disable-setuid                       \
#              --with-browser=/usr/bin/lynx           \
#              --with-vgrind=/usr/bin/vgrind          \
#              --with-grap=/usr/bin/grap')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.56. Patch-2.7.1
#with pkg('patch-2.7.1'):
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')

## 6.57. Sysklogd-1.5
#with pkg('sysklogd-1.5'):
#    shch('make')
#    shch('make BINDIR=/sbin install')
#    with open('/etc/syslog.conf', 'w') as fp:
#        fp.write('# Begin /etc/syslog.conf\n'
#                 '\n'
#                 'auth,authpriv.* -/var/log/auth.log\n'
#                 '*.*;auth,authpriv.none -/var/log/sys.log\n'
#                 'daemon.* -/var/log/daemon.log\n'
#                 'kern.* -/var/log/kern.log\n'
#                 'mail.* -/var/log/mail.log\n'
#                 'user.* -/var/log/user.log\n'
#                 '*.emerg *\n'
#                 '\n'
#                 '# End /etc/syslog.conf\n')

## 6.58. Sysvinit-2.88dsf
#with pkg('sysvinit-2.88dsf'):
#    shch("sed -i 's@Sending processes@& configured via /etc/inittab@g' src/init.c")
#    shch("sed -i -e '/utmpdump/d'                  \
#                 -e '/mountpoint/d' src/Makefile")
#    shch('make -C src')
#    shch('make -C src install')

## 6.59. Tar-1.26
#with pkg('tar-1.26'):
#    shch("sed -i -e '/gets is a/d' gnu/stdio.in.h")
#    shch('FORCE_UNSAFE_CONFIGURE=1     \
#          ./configure --prefix=/usr    \
#              --bindir=/bin            \
#              --libexecdir=/usr/sbin')
#    shch('make')
#    shch('make check')
#    shch('make install')
#    shch('make -C doc install-html docdir=/usr/share/doc/tar-1.26')

# 6.60. Texinfo-5.0
#with pkg('texinfo-5.0'):
#    shch('./configure --prefix=/usr')
#    shch('make')
#    shch('make check')
#    shch('make install')
#    shch('make TEXMF=/usr/share/texmf install-tex')

# 6.61. Udev-197 (Extracted from systemd-197)
#with pkg('systemd-197'):
#    shch('tar -xvf ../udev-lfs-197-2.tar.bz2')
#    shch('make -f udev-lfs-197-2/Makefile.lfs')
#    shch('make -f udev-lfs-197-2/Makefile.lfs install')
#    shch('build/udevadm hwdb --update')
#    shch('bash udev-lfs-197-2/init-net-rules.sh')

## 6.62. Vim-7.3
#with pkg('vim73', 'vim-7.3'):
#    shch("echo \"#define SYS_VIMRC_FILE '/etc/vimrc'\" >> src/feature.h")
#    shch('./configure              \
#              --prefix=/usr        \
#              --enable-multibyte')
#    shch('make')
#    shch('make test')
#    shch('make install')
#
#    shch('ln -sv vim /usr/bin/vi')
#    # FIXME
#    shch('ln -sv ../vim/vim73/doc /usr/share/doc/vim-7.3')
#    with open('/etc/vimrc', 'w') as fp:
#        fp.write('" Begin /etc/vimrc\n'
#                 '\n'
#                 'set nocompatible\n'
#                 'set backspace=2\n'
#                 'syntax on\n'
#                 'if (&term == "iterm") || (&term == "putty")\n'
#                 '  set background=dark\n'
#                 'endif\n'
#                 '\n'
#                 '" End /etc/vimrc\n')


# 6.64. Stripping Again
# FIXME
