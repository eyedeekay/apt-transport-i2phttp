apt-transport-i2phttp, HTTP-based I2P Transport for apt
=======================================================

This is a simple transport for downloading debian packages from a repository
over i2p. It uses the built-in HTTP proxy or one you configure. It's a
modified version of [diocles/apt-tranport-http-golang](https://github.com/diocles/apt-transport-http-golang),
a plain HTTP Transport for apt.

Besides that, I think most would agree that it is simpler to use an apt
transport to detect when a package should be retrieved from an i2p service.
Especially in cases where the user is mixing packages from Tor, I2P, and
Clearnet sources, this process can become confusing and involve configuring
multiple applications along with apt. Instead, apt-transport-i2phttp works with
other apt transports like apt-transport-tor and even apt-transport-i2p(A SAM
based alternate i2p transport), requiring no configuration on the vast majority
of systems.

To install it:
--------------

If you're on Ubuntu and want to fetch it from the github release, you can run
these 2 commands.

		wget https://github.com/eyedeekay/apt-transport-i2phttp/releases/download/0.4/default.$(lsb_release -s -c)-apt-transport-i2phttp_0.4_amd64.deb
		dpkg -i default.$(lsb_release -s -c)-apt-transport-i2phttp_0.4_amd64.deb

If you're on Debian, you'll need to use this for stable:

		wget https://github.com/eyedeekay/apt-transport-i2phttp/releases/download/0.4/default.stable-apt-transport-i2phttp_0.4_amd64.deb
		dpkg -i default.stable-apt-transport-i2phttp_0.4_amd64.deb

this for testing:

		wget https://github.com/eyedeekay/apt-transport-i2phttp/releases/download/0.4/default.testing-apt-transport-i2phttp_0.4_amd64.deb
		dpkg -i default.testing-apt-transport-i2phttp_0.4_amd64.deb

and this for sid:

		wget https://github.com/eyedeekay/apt-transport-i2phttp/releases/download/0.4/default.unstable-apt-transport-i2phttp_0.4_amd64.deb
		dpkg -i default.unstable-apt-transport-i2phttp_0.4_amd64.deb

Once you've done that, run these 2 commands:

		http_proxy=http://127.0.0.1:4444 wget -O - 'http://apt.idk.i2p/key.asc' | sudo apt-key add - 
		echo deb i2p://apt.idk.i2p unstable main | sudo tee /etc/apt/sources.list.d/apt.idk.i2p.list

As long as you have an i2p router installed the http proxy should be enabled
by default. You can just:

        make build && sudo make install

to install ./apt-transport-i2phttp to /usr/lib/apt/methods/i2p, requiring no
additional configuration.

To use it:
----------

There aren't very many apt repositories inside of I2P yet, the 2 that I know
about are both operated by me. One is an apt-cacher-ng proxy, which is effectively
a means of fetching clearnet debian packages from with I2P. You can use it with an
apt line something like this:

		deb i2p://ul5nnihwk5v67iutqn6ac3fdy32acmc7socjjncwyshywmbz36ea.b32.i2p/deb.debian.org/debian stable main

In this case, the caching proxy is the host where you fetch packages from, and
the path is the desired Debian package repository.

Alternatively, there may be actual package repositories inside of I2P you wish to
use it, like my experimental packages repository, you would just use the repository
hostname instead, like this:

		deb i2p://apt.idk.i2p unstable main

Of course, to install packages from this repository, you'll need to fetch the repo
key.

        http_proxy=http://127.0.0.1:4444 wget -O - 'http://apt.idk.i2p/key.asc' | sudo apt-key add - 

To build a proper deb of it:
----------------------------

Building a release is done with pbuilder to avoid building a release with
packages not in the appropriate version of Debian or Ubuntu. Use 
```pbuilder create``` to set up the chroot appropriate to your target
distribution. Then, in the root of the repository directory, run the command
```debuild -s``` to generate a .dsc file in the parent directory. Now that you
have the ,dsc file, create a build directory using ```mkdir -p deb/targetdistro``` 
and run ```pbuilder build --buildresult ./deb/stable``` to generate your actual
deb packages. Of course, you'll have to adjust the commands to suit the target
distribution. And you have to do it for every single distribution you want to
build for.

You *must* have this line specified in your ~/.pbuilderrc file:

		PBUILDERSATISFYDEPENDSCMD=/usr/lib/pbuilder/pbuilder-satisfydepends-apt

and, if you wish to build for both Debian *and* Ubuntu, you must not specify a
mirror in your ~/.pbuilderrc or the mirror specified by the --mirror flag will
not be honored.

I have the release.sh script in the root of this repo
that I use to make my life easier. It should also be pretty easy to understand.
From the repository directory, run the script like:

        $pathtoscript/release.sh stable

so to build for like a whole bunch of releases(With it installed as release-pdeb
in /usr/local/bin):

        release-pdeb stable
        release-pdeb testing
        release-pdeb unstable
        release-pdeb bionic
        release-pdeb eoan
        release-pdeb focal


To Release it:
--------------

This software is released in 2 places, an out-of-network source and an in-network
source. The out-of-network source is this github repository's release section.
Other mirrors can be made available by others but this is the official one. If you
want to release to your own github mirror, set the USERNAME environment variable
and run the command ```make github-release```.


