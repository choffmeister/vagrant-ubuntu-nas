# vagrant-ubuntu-nas

This is a simple description of a [Vagrant](https://www.vagrantup.com) virtual machine that is supposed to demonstrate how to build up your own NAS based on [Ubuntu Server 14.04 (64-bit)](http://www.ubuntu.com/server).

## Usage

Clone this repository and fire up the Vagrant machine by running:

~~~ bash
$ git clone https://github.com/choffmeister/vagrant-ubuntu-nas.git
$ cd vagrant-ubuntu-nas
$ vagrant up
~~~

## Features

* Simulates a three disk setup combined together to a single drive with [mhddfs](http://manpages.ubuntu.com/manpages/trusty/man1/mhddfs.1.html).
* Allows to import media for test purposes by putting files into the `media/` folder of this repository - the files are then accessible at `/vagrant/media/` from within the virtual machine.
* Installs [Plex Media Server](https://plex.tv/) - the web interface can be access by navigating to [http://localhost:32400/web]().
