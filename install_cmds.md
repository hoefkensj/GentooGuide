```bash
isu -c 'nohup qterminal & '
tmux

#VARIABLES
export ROOT_NEW="/mnt/gentoo"
export ROOT_OLD="/"
export MIRROR="http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/"
#export LATEST="latest-stage3-amd64-desktop-systemd-mergedusr.txt"
export LATEST="latest-stage3-amd64-systemd-mergedusr.txt"
export STAGE3_URL="${MIRROR}$(curl  --silent $MIRROR$LATEST | tail -n1 |awk '{print $1}')"
# DIRS
install -m 777 -d "$ROOT_OLD"/mnt/{gentoo/,install/}

# FORMATTING :

mkfs.f2fs -f -l GENTOO -O extra_attr,inode_checksum,sb_checksum,flexible_inline_xattr -w 4096 /dev/disk/by-partlabel/GENTOO

#Mounting: 

#the new root Volume:
mount -t f2fs -o rw,relatime,lazytime,background_gc=on,discard,no_heap,inline_xattr,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,active_logs=6,alloc_mode=default,checkpoint_merge,fsync_mode=posix,discard_unit=block  /dev/disk/by-label/GENTOO /mnt/gentoo
#the Installation Files 
mount -o size=1G -t tmpfs tmpfs /mnt/Install

#creating some intallationfile directories:
install -m 777 -d "$ROOT_OLD"/mnt/install/{git,scripts,gentoo-stage3}
#Gathering The Gentoo Stage tarbal
cd /mnt/install/gentoo-stage3 
wget -c "${STAGE3_URL}"
wget -c "${STAGE3_URL}.CONTENTS.gz"
wget -c "${STAGE3_URL}.DIGESTS"
wget -c "${STAGE3_URL}.asc"
wget -c "${STAGE3_URL}.sha256"
wget -O - https://qa-reports.gentoo.org/output/service-keys.gpg | gpg --import
gpg --keyserver hkps://keys.gentoo.org --recv-keys D99EAC7379A850BCE47DA5F29E6438C817072058
gpg --verify "${LATEST}.asc"
gpg --verify stage3-amd64-*.tar.xz.DIGESTS.asc
awk '/SHA512 HASH/{getline;print}' stage3-amd64-*.tar.xz.DIGESTS.asc | sha512sum --check 

#scripts & programs
cd /mnt/install/
mkdir -p /mnt/install/scripts/superadduser
curl https://gitweb.gentoo.org/repo/gentoo.git/plain/app-admin/superadduser/files/1.15/superadduser -o  /mnt/install/scripts/superadduser/superadduser.sh 

mkdir -p /mnt/install/scripts/sourcedir
curl https://raw.githubusercontent.com/hoefkensj/SourceDir/main/sourcedir-latest.sh -o /mnt/install/scripts/sourcedir/sourcedir-latest.sh
#install scripts in new installation:
mkdir -m 775 /opt/{sh,bin,scripts,local/{bin,sh,scripts}}

git -c /mnt/install/git clone https://github.com/hoefkensj/bash_scripts.git
git -C /mnt/install/git clone https://github.com/hoefkensj/GentooGuide/
git -C /mnt/install/git clone https://github.com/projg2/cpuid2cpuflags.git
git -C /mnt/install/git clone https://github.com/zyedidia/micro
git -C /mnt/install/git clone https://github.com/jvz/psgrep
git -C /mnt/install/git clone https://github.com/sakaki-/showem.git
git -C /mnt/install/git clone https://github.com/rcaloras/bashhub-client.git
git -C /mnt/install/git clone https://github.com/sharkdp/fd
git -C /mnt/install/git clone https://github.com/BurntSushi/ripgrep
git -C /mnt/install/git clone https://github.com/sharkdp/bat
git -C /mnt/install/git clone https://github.com/ogham/exa
git -C /mnt/install/git clone https://github.com/tldr-pages/tldr
git -C /mnt/install/git clone https://github.com/junegunn/fzf
git -C /mnt/install/git clone https://github.com/ajeetdsouza/zoxide
```

### UNPacking and moving stuff

```bash
tar xpvJf /mnt/install/gentoo-stage3/stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner --directory /mnt/gentoo
# x:extract, p:preserve permissions, J:xz-compression f:file

#portage
mkdir -pv $ROOT_NEW/{Volumes,etc/portage/{package.{accept_keywords,license,mask,unmask,use,env},repos.conf},opt/{bin,scripts,local/{bin,scripts,config/rc/bash}}}
chown -Rv root:100 $ROOT_NEW/{opt,Volumes}
chmod -Rv 775 $ROOT_NEW/{opt,Volumes}
```

## configuring the new /etc/portage/make.conf

```bash
#backup the original :
mkdir -pv $ROOT_NEW/root/backups/etc/
cp -vfr $ROOT_NEW/etc/portage $ROOT_NEW/root/backups/etc/
```

```bash
cd $ROOT_NEW/etc/portage/ 
echo > make.conf <<< echo '''#!/usr/bin/env bash
# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.'''
```

```bash
echo >> make.conf <<< echo \
'''
CHOST="x86_64-pc-linux-gnu"
ACCEPT_LICENSE="*"
ACCEPT_KEYWORDS="amd64"
ABI_X86="32 64"
'''

```

```bash
#no need for cpu_flags_x86 here anymore so:
echo "*/* $(cpuid2cpuflags)" >> $ROOT_NEW/etc/portage/package.use/00cpuflags
```



```bash



echo >> make.conf <<< echo \
'''
COMMON_FLAGS="-O2 -pipe"
COMMON_FLAGS="${COMMOM_FLAGS} $(gcc -march=native -E -v - </dev/null 2>&1 | sed  -n 's/.* -v - //p')"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
# NOTE: This stage was built with the bindist Use flag enabled
PORTDIR="/var/db/repos/gentoo"
DISTDIR="/var/cache/distfiles"
PKGDIR="/var/cache/binpkgs"

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C
L10N="en"

# MAKEOPTS="-j1" 
MAKEOPTS="-j6 -l6"


# EMERGE_DEFAULT_OPTS
# -v --verbose      # -b --buildpkg     # -D --deep             # -g --getbinpkg        # -k --usepkg
# -u update            # -N --newuse       # -l load-average        # -t --tree                # -G --getbinpkgonly
# -k --uspkgonly    # -U changed-use    # -o --fetchonly        # -a ask                # -f --fuzzy-search
# --list-sets        # --alphabetical    # --color=y             # --with-bdeps=y        # --verbose-conflicts
# --complete-graph=y                    # --backtrack=COUNT                             # --binpkg-respect-use=[y/n]
# --autounmask=y                        # --autounmask-continue=y                          # --autounmask-backtrack=y
# --autounmask-write=y                     # --usepkg-exclude 'sys-kernel/gentoo-sources virtual/*'
# EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --jobs=9 -b -v -D" --tree, -t--verbose-conflicts

AUTOUNMASK=""
AUTOUNMASK="${AUTOUNMASK} --autounmask=y  --autounmask-continue=y --autounmask-write=y"
AUTOUNMASK="${AUTOUNMASK} --autounmask-unrestricted-atoms=y --autounmask-license=y"
AUTOUNMASK="${AUTOUNMASK} --autounmask-use=y --autounmask-write=y"

EMERGE_DEFAULT_OPTS="--verbose"
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --jobs=4 --load-average=4"
#EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --with-bdeps=y "
#EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} ${AUTOUNMASK}"
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --color=y --alphabetical --verbose-conflicts"


#GENTOO_MIRRORS=""
#### BELGIUM | BELNET
GENTOO_MIRRORS="${GENTOO_MIRRORS} http://ftp.belnet.be/mirror/rsync.gentoo.org/gentoo/"
GENTOO_MIRRORS="${GENTOO_MIRRORS} https://ftp.belnet.be/mirror/rsync.gentoo.org/gentoo/"
GENTOO_MIRRORS="${GENTOO_MIRRORS} ftp://ftp.belnet.be/mirror/rsync.gentoo.org/gentoo/"
GENTOO_MIRRORS="${GENTOO_MIRRORS} rsync://rsync.belnet.be/gentoo/"
#### LUXEMBURG
GENTOO_MIRRORS="${GENTOO_MIRRORS} http://gentoo.mirror.root.lu/"
GENTOO_MIRRORS="${GENTOO_MIRRORS} https://gentoo.mirror.root.lu/"
GENTOO_MIRRORS="${GENTOO_MIRRORS} ftp://mirror.root.lu/gentoo/"
##### NETHERLANDS | UNIVERSITY TWENTE
GENTOO_MIRRORS="${GENTOO_MIRRORS} http://ftp.snt.utwente.nl/pub/os/linux/gentoo"
GENTOO_MIRRORS="${GENTOO_MIRRORS} https://ftp.snt.utwente.nl/pub/os/linux/gentoo"
GENTOO_MIRRORS="${GENTOO_MIRRORS} ftp://ftp.snt.utwente.nl/pub/os/linux/gentoo"
GENTOO_MIRRORS="${GENTOO_MIRRORS} rsync://ftp.snt.utwente.nl/gentoo/"
#### NETHERLANDS | LEASWEB
GENTOO_MIRRORS="${GENTOO_MIRRORS} http://mirror.leaseweb.com/gentoo/"
GENTOO_MIRRORS="${GENTOO_MIRRORS} https://mirror.leaseweb.com/gentoo/"
GENTOO_MIRRORS="${GENTOO_MIRRORS} ftp://mirror.leaseweb.com/gentoo/"
GENTOO_MIRRORS="${GENTOO_MIRRORS} rsync://mirror.leaseweb.com/gentoo/"
###########################


GRUB_PLATFORM="efi-64"
ALSA_CARDS="hda-intel usb-audio emu10k1 emu10k1x emu20k1x emu20k1 intel8x0 intel8x0m bt87x hdsp hdspm ice1712 mixart rme32 rme96 sb16 sbawe sscape usb-usx2y vx222"
VIDEO_CARDS="nvidia d3d12 vmware"
INPUT_DEVICES="evdev libinput"
INPUT_DRIVERS="evdev"

USE=
'''
```

'

'

```bash
echo "*/* $(cpuid2cpuflags)" >> /mnt/gentoo/etc/portage/package.use/00cpuflags
mkdir -p -v $ROOT_NEW/etc/portage/repos.conf 
cp -v $ROOT_NEW/usr/share/portage/config/repos.conf $ROOT_NEW/etc/portage/repos.conf/gentoo.conf 
```

## PORTAGE

### Create Some local Repositories

```
eselect repository create gentoo_legacy
eselect repository create kranklab
eselect repository create kranklab_bump
```

## Configuring /etc/portage/make.conf

```bash
mkdir -p -v /mnt/gentoo/etc/portage/repos.conf 
# Turn on logging - see http://gentoo-en.vfose.ru/wiki/Gentoo_maintenance.
#PORTAGE_ELOG_CLASSES="info warn error log qa"
# Echo messages after emerge, also save to /var/log/portage/elog
#PORTAGE_ELOG_SYSTEM="echo save"

USE_BASE="acl amd64 bzip2 cli crypt dri fortran gdbm iconv ipv6 libglvnd libtirpc multilib ncurses nls nptl openmp pam pcre readline seccomp ssl systemd test-rust udev unicode xattr zlib"
USE_DESKTOP="X a52 aac acpi alsa bluetooth branding cairo cdda cdr crypt cups dbus dts dvd dvdr encode exif flac gif gpm gtk gui iconv icu jpeg lcms libnotify mad mng mp3 mp4 mpeg ogg opengl pango pdf png policykit ppds qt5 sdl sound spell startup-notification svg tiff truetype udisks upower usb vorbis wxwidgets x264 xcb xft xml xv xvid"
USE_PLASMA="activities declarative kde kwallet plasma qml semantic-desktop widgets xattr"
USE_PLASMA="activities declarative kde plasma qml semantic-desktop widgets xattr"

USE="tools custom-cflags network multimedia  "
"gles2 opencl tools \
persistenced \
libsamplerate opencv custom-cflags grub network  \
dri semantic-desktop \
modplug modules \
multimedia   ao \
audiofile  branding cairo cdb cdda cddb cdr cgi \
colord crypt css curl dbm dga dts dv dvb dvd dvdr encode exif \
fbcon ffmpeg fftw flac fltk fontconfig fortran ftp gd gif \
glut gnuplot gphoto2 graphviz gzip handbook imagemagick imap \
imlib ipv6 java javascript joystick jpeg kerberos ladspa lame \
lcms ldap libcaca libnotify libwww lua lzma lz4 lzo mad magic \
man matroska mikmod mmap mms mono mp3 mp4 mpeg mplayer mtp \
mysqli nas ncurses nsplugin offensive ogg openal opus osc pda \
pdf php plotutils png postscript radius raw rdp rss ruby samba \
sasl savedconfig sdl session smartcard smp sndfile snmp \
sockets socks5 sound sox speex spell sqlite ssl \
startup-notification suid svg symlink szip tcl tcpd theora tidy tiff timidity \
tk  udev udisks  upnp-av upower v4l vaapi vcd \
videos vim-syntax vnc vorbis  webkit webp wmf wxwidgets \
 xattr xcomposite xine xinerama xinetd xml xmp xmpp xosd \
xpm xv   zlib zsh-completion zstd source \
 script openexr echo-cancel extra gstreamer jack-sdk lv2 \
 sound-server system-service v4l2 zimg \
rubberband pulseaudio libmpv gamepad drm cplugins archive screencast \
gbm   examples "
```

```bash
#Database
sqlite,mysql,berkdb,dbi,dbm,
#Codecs:
a52,aac,aalib,audiofile,cdb,nvenc,libsamplerate,otf,ttf,quicktime,xvid,truetype,x265,wavpack,css
#Cli
aalib,bash-completion
#Hardware
acpi,ao,bluetooth,cdr,pipewire,jack,nvidia,thunderbolt,usb,jack,rtaudio,systemd,dbus,nvme,uefi,lm-sensors,hddtemp,alsa,sensors,midi,pipewire-alsa,upnp,coreaudio
#Filesystem
afs
#Network
apache2,atm,cddb,curl,iwd,wifi,network,nftables,,zeroconf ,adns,connman,
#Gui
appindicator,cairo,colord,wayland,plasma,opengl,X,kde,vulkan,qt5,Xaw3d,colord,
#Development
python,designer,cuda
#tools
bash-completion,crypt,git
# Archiving
7zip,bzip2,rar,zip 
# Unknown
accessibility,acl,apparmor,audit,bidi,big-endian,bindist,blas,branding,build,calendar,caps,cdinstall,cgi,cjk,clamav,cracklib,
crypt,cxx,dbus,debug,
```

```bash
mkdir -p -v /mnt/gentoo/etc/portage/repos.conf 
cp -v /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf 
nano -w /mnt/gentoo/etc/portage/repos.conf/gentoo.conf 
```

```ini
/mnt/gentoo/etc/portage/repos.conf/gentoo.confSetting up repository information for Portage

[DEFAULT]
main-repo = gentoo

[gentoo]
location = /var/db/repos/gentoo
sync-type = webrsync
#sync-type = rsync
sync-uri = rsync://rsync.gentoo.org/gentoo-portage
sync-webrsync-verify-signature = true
auto-sync = yes

sync-rsync-verify-jobs = 1
sync-rsync-verify-metamanifest = yes
sync-rsync-verify-max-age = 24
sync-openpgp-keyserver = hkps://keys.gentoo.org
sync-openpgp-key-path = /usr/share/openpgp-keys/gentoo-release.asc
sync-openpgp-key-refresh-retry-count = 40
sync-openpgp-key-refresh-retry-overall-timeout = 1200
sync-openpgp-key-refresh-retry-delay-exp-base = 2
sync-openpgp-key-refresh-retry-delay-max = 60
sync-openpgp-key-refresh-retry-delay-mult = 4
```

```
emaint sync --auto 
emerge --ask --verbose --oneshot portage 
echo "Europe/Brussels" > /etc/timezone 
emerge -v --config sys-libs/timezone-data 
nano -w /etc/locale.gen
locale-gen 
eselect locale list 
eselect locale set "C" 
env-update && source /etc/profile && export PS1="(chroot) $PS1"
touch /etc/portage/package.use/zzz_via_autounmask 
emerge --ask --verbose dev-vcs/git 
```

```
nano -w /etc/portage/repos.conf/sakaki-tools.conf 
[sakaki-tools]

# Various utility ebuilds for Gentoo on EFI
# Maintainer: sakaki (sakaki@deciban.com)

location = /var/db/repos/sakaki-tools
sync-type = git
sync-uri = https://github.com/sakaki-/sakaki-tools.git
priority = 50
auto-sync = yes
```

```
emaint sync --repo sakaki-tools 
echo '*/*::sakaki-tools' >> /etc/portage/package.mask/sakaki-tools-repo 
touch /etc/portage/package.unmask/zzz_via_autounmask 
echo "app-portage/showem::sakaki-tools" >> /etc/portage/package.unmask/showem

echo "app-portage/genup::sakaki-tools" >> /etc/portage/package.unmask/genup
echo "app-crypt/staticgpg::sakaki-tools" >> /etc/portage/package.unmask/staticgpg
echo "app-crypt/efitools::sakaki-tools" >> /etc/portage/package.unmask/efitools
touch /etc/portage/package.accept_keywords/zzz_via_autounmask 
#echo "*/*::sakaki-tools ~amd64" >> /etc/portage/package.accept_keywords/sakaki-tools-repo 
echo -e "# all versions of efitools currently marked as ~ in Gentoo tree\napp-crypt/efitools ~amd64" >> /etc/portage/package.accept_keywords/efitools 
echo "~sys-apps/busybox-1.32.0 ~amd64" >> /etc/portage/package.accept_keywords/busybox 
```