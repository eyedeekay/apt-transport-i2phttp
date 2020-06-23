#! /usr/bin/env sh

set -x

echo $USERNAME

if [ -z $USERNAME ]; then
	USERNAME=$USERNAME
fi

debversion=sid
if [ ! -z $1 ]; then
	debversion=$1
fi

PKG=$(basename $(pwd))

VERSION=$(head -n 1 debian/changelog | sed "s|$PKG (||g" | sed 's|).*||')

DEBIANS="stable testing unstable experimental wheezy jessie stretch buster bullseye bookworm sid"

debrepo="--mirror http://us.archive.ubuntu.com/ubuntu"

for debian in $DEBIANS; do
    if [ $1 = "$debian" ]; then
        echo "$debian detetced"
        debrepo=""
    fi
done

setup(){
    install -m755 ./release.sh /usr/bin/release-pdeb
}

upload(){
    cd deb
    gothub release -u $USERNAME -r $PKG -t $VERSION -n $dist-$name || exit 1
	for bin in $(find . -name '*.deb'); do
        dist=$(dirname $bin)
        name=$(basename $bin)
        gothub upload -R -u $USERNAME -r $PKG -t $VERSION -n $dist-$name -f $bin 
    done
	for bin in $(find . -name '*.orig.tar.gz'); do
        dist=$(dirname $bin)
        name=$(basename $bin)
        gothub upload -R -u $USERNAME -r $PKG -t $VERSION -n $dist-$name -f $bin 
    done
	for bin in $(find . -name '*.tar.xz'); do
        dist=$(dirname $bin)
        name=$(basename $bin)
        gothub upload -R -u $USERNAME -r $PKG -t $VERSION -n $dist-$name -f $bin 
    done
	for bin in $(find . -name '*.dsc'); do
        dist=$(dirname $bin)
        name=$(basename $bin)
        gothub upload -R -u $USERNAME -r $PKG -t $VERSION -n $dist-$name -f $bin 
    done
	for bin in $(find . -name '*.changes'); do
        dist=$(dirname $bin)
        name=$(basename $bin)
        gothub upload -R -u $USERNAME -r $PKG -t $VERSION -n $dist-$name -f $bin 
    done
	for bin in $(find . -name '*.buildinfo'); do
        dist=$(dirname $bin)
        name=$(basename $bin)
        gothub upload -R -u $USERNAME -r $PKG -t $VERSION -n $dist-$name -f $bin 
    done
    cd ..
}

releasebuild() {
    if test -f "/var/cache/pbuilder/$1.tgz" ; then
        echo "updating chroot for $1 in /var/cache/pbuilder/$1.tgz"
        sudo -E pbuilder update --debootstrapopts --variant=buildd --debootstrapopts --exclude=aptitude --basetgz "/var/cache/pbuilder/$1.tgz" --distribution "$1" $debrepo
    else
        echo "creating chroot for $1 in /var/cache/pbuilder/$1.tgz"
        sudo -E pbuilder create --basetgz "/var/cache/pbuilder/$1.tgz" --distribution "$1" $debrepo --debootstrapopts --variant=buildd --debootstrapopts --exclude=aptitude
    fi
    echo "building for $1"
    echo "generating source"
    tar --exclude=.git --exclude=debian --exclude deb -czvf ../$PKG_$VERSION.orig.tar.gz .
    debuild -S
    echo "making output directory ./deb/$1"
    mkdir -p "./deb/$1"
    echo "sudo -E pbuilder build --buildresult ./deb/$1 $debrepo --distribution $1 ../""$2""_$VERSION.dsc "
    sudo -E pbuilder build --basetgz "/var/cache/pbuilder/$1.tgz" --buildresult "./deb/$1" $debrepo --distribution $1 "../""$2""_$3.dsc"
    sudo chown -R $(whoami):$(whoami) deb
}

if [ "install" = "$1" ]; then
    setup || exit 1
    exit 0
fi

if [ "upload" = "$1" ]; then
    upload || exit 1
    exit 0
fi

if [ ! -z $1 ]; then
    releasebuild $1 "$PKG" "$VERSION"
else
    releasebuild stable "$PKG" "$VERSION"
fi
