
apt-transport-i2phttp:
	go build \
		-a \
		-tags netgo \
		-ldflags '-w -extldflags "-static"'

install: apt-transport-i2phttp
	install -m755 apt-transport-i2phttp /usr/lib/apt/methods/i2p

clean:
	go clean
