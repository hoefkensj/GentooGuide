## Stage 3

### Automate the Stage3 Downloads (tarbal and verificationkeys)

```bash
export MIRROR="http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds/"
export LATEST="latest-stage3-amd64-desktop-systemd-mergedusr.txt"
export STAGE3_URL="${MIRROR}$(curl  --silent $MIRROR$LATEST | tail -n1 |awk '{print $1}')"
```

### Downloading the files

```bash
mkdir -p /mnt/Install/gentoo-stage3
cd $_
wget -c "${STAGE3_URL}"
wget -c "${STAGE3_URL}.CONTENTS.gz"
wget -c "${STAGE3_URL}.DIGESTS"
wget -c "${STAGE3_URL}.asc"
wget -c "${STAGE3_URL}.sha256"
```

### GENTOO Signing keys

```bash
wget -O - https://qa-reports.gentoo.org/output/service-keys.gpg | gpg --import
```

or only the release signing key: (automated)

```bash
gpg --keyserver hkps://keys.gentoo.org --recv-keys D99EAC7379A850BCE47DA5F29E6438C817072058
```

### Verifying the Downloads

```bash
gpg --verify "${LATEST}.asc"
gpg --verify stage3-amd64-*.tar.xz.DIGESTS.asc
awk '/SHA512 HASH/{getline;print}' stage3-amd64-*.tar.xz.DIGESTS.asc | sha512sum --check 
```

### Unpack the verified stage 3 archive

```bash
tar xpvJf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner --directory /mnt/gentoo
# x:extract, p:preserve permissions, J:xz-compression f:file

```

## Some Extra Folders

```BASH
mkdir -p /mnt/gentoo/{Volumes,etc/portage/{package.{accept_keywords,license,mask,unmask,use,env},repos.conf},opt/{bin,scripts,local/{bin,scripts,config/rc/bash}}}
mkdir -p /mnt/install/{git,scripts/{superadduser,sourcedir}}
chown -R root:100 ./{opt,Volumes}
chmod -R 775 ./{opt,Volumes}


```

## Extra Scripts

### superadduser (Slackware)

```bash
curl https://gitweb.gentoo.org/repo/gentoo.git/plain/app-admin/superadduser/files/1.15/superadduser -o  /mnt/install/scripts/superadduser/superadduser.sh 
```

### sourcedir (HoefkensJ)

```bash
curl https://raw.githubusercontent.com/hoefkensj/SourceDir/main/sourcedir-latest.sh -o /mnt/install/scripts/sourcedir/sourcedir-latest.sh
```

### local system bashrc (HoefkensJ)

```bash
git -C /mnt/install/git clone https://github.com/hoefkensj/GentooGuide.git
```

### Gentoolkit (Gentoo)

````bash
git -C /mnt/install/git clone https://github.com/gentoo/gentoolkit.git
````
