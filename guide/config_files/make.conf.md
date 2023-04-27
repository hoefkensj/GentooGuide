```bash
#!/usr/bin/env bash
# These settings were set by the catalyst build script that automatically
# built this stage.
# Please consult /usr/share/portage/config/make.conf.example for a more
# detailed example.
CHOST="x86_64-pc-linux-gnu"
ACCEPT_LICENSE="*"
ACCEPT_KEYWORDS="amd64"
ABI_X86="32 64"
```

```bash
COMMON_FLAGS="-O2 -pipe"
# gcc -march=native -E -v - </dev/null 2>&1 | sed  -n 's/.* -v - //p'
```

```bash
COMMON_FLAGS="${COMMOM_FLAGS} <output gcc -march=native -E -v - </dev/null 2>&1 | sed  -n 's/.* -v - //p' here>"
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
```

```bash
# MAKEOPTS="-j1"
MAKEOPTS="-j1 -l1"


# EMERGE_DEFAULT_OPTS
# -v --verbose      # -b --buildpkg     # -D --deep             # -g --getbinpkg        # -k --usepkg
# -u update         # -N --newuse       # -l --load-average     # -t --tree             # -G --getbinpkgonly
# -k --uspkgonly    # -U changed-use    # -o --fetchonly        # -a ask                # -f --fuzzy-search
# --list-sets       # --alphabetical    # --color=y             # --with-bdeps=y        # --verbose-conflicts
# --complete-graph=y                    # --backtrack=COUNT                             # --binpkg-respect-use=[y/n]
# --autounmask=y                        # --autounmask-continue=y                       # --autounmask-backtrack=y
# --autounmask-write=y                  # --usepkg-exclude 'sys-kernel/gentoo-sources virtual/*'
# EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --jobs=9 -b -v -D" --tree, -t--verbose-conflicts

AUTOUNMASK=""
AUTOUNMASK="${AUTOUNMASK} --autounmask=y  --autounmask-continue=y --autounmask-write=y"
AUTOUNMASK="${AUTOUNMASK} --autounmask-unrestricted-atoms=y --autounmask-license=y"
AUTOUNMASK="${AUTOUNMASK} --autounmask-use=y --autounmask-write=y"

EMERGE_DEFAULT_OPTS="--verbose"
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --jobs=1"
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --with-bdeps=y "
EMERGE_DEFAULT_OPTS="${EMERGE_DEFAULT_OPTS} --color=y --verbose-conflicts"
```

```bash
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
```

```bash


ALSA_CARDS="hda-intel usb-audio emu20k1x emu20k2 intel8x0 intel8x0m bt87x hdsp hdspm ice1712 mixart rme32 rme96 sb16 sbawe sscape usb-usx2y vx222"
VIDEO_CARDS="nvidia d3d12 vmware"
INPUT_DEVICES="evdev libinput"
INPUT_DRIVERS="evdev"

USE_BASE="acl amd64 bzip2 cli crypt dri fortran gdbm iconv ipv6 libglvnd libtirpc multilib ncurses nls nptl openmp pam pcre readline seccomp ssl systemd test-rust udev unicode xattr zlib"
USE_DESKTOP="X a52 aac acpi alsa bluetooth branding cairo cdda cdr crypt cups dbus dts dvd dvdr encode exif flac gif gpm gtk gui iconv icu jpeg lcms libnotify mad mng mp3 mp4 mpeg ogg opengl pango pdf png policykit ppds qt5 sdl sound spell startup-notification svg tiff truetype udisks upower usb vorbis wxwidgetsx264 xcb xft xml xv xvid"
USE_PLASMA="activities declarative kde kwallet plasma qml semantic-desktop widgets xattr"
```

