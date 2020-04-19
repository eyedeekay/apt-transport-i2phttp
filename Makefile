
PKG=`basename $(PWD)`

VERSION=$(shell head -n 1 debian/changelog | sed "s|$(PKG) (||g" | sed 's|).*||')

echo:
	@echo "$(VERSION)"

apt-transport-i2phttp:
	go build \
		-a \
		-tags netgo \
		-ldflags '-w -extldflags "-static"'

install:
	install -m755 apt-transport-i2phttp /usr/lib/apt/methods/i2p

clean:
	go clean

orig:
	tar --exclude=.git --exclude=debian -czvf ../apt-transport-i2phttp_$(VERSION).orig.tar.gz .

release: ubuntu debian

debian:
	./release.sh stable
	./release.sh testing
	./release.sh unstable

ubuntu:
	./release.sh bionic
	./release.sh eoan
	./release.sh focal

github-release: release
	./release.sh upload

