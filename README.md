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

As long as you have an i2p router installed the http proxy should be enabled
by default. You can just:

        make build && sudo make install

to install ./apt-transport-i2phttp to /usr/lib/apt/methods/i2p, requiring no
additional configuration.

To use it:
---------

To add an eepSite to your sources.list, for example(This example site is down,
I'll have a new one for you to use shortly):

        deb i2p://http://wnhxwrq4fkn3cov6bnqsdaniubeo3625rmsm53yaz336bxvtiqeq.b32.i2p/deb-pkg rolling main