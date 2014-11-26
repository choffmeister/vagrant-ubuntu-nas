# vagrant-ubuntu-nas

This is a simple description of a [Vagrant](https://www.vagrantup.com) virtual machine that is supposed to demonstrate how to build up your own NAS based on [Ubuntu Server 14.04 (64-bit)](http://www.ubuntu.com/server).

## Usage

Clone this repository and fire up the Vagrant machine by running:

~~~ bash
# clone this repo
$ git clone https://github.com/choffmeister/vagrant-ubuntu-nas.git
$ cd vagrant-ubuntu-nas

# start and configure the virtual machine
$ vagrant up

# SSH into the machine
$ vagrant ssh

# optional: install plexmediaserver
$ sudo /vagrant/bin/install-plexmediaserver.sh
~~~

You can create user accounts by:

~~~ bash
# create a new unix- and samba-user
$ sudo /vagrant/bin/user-new.sh
~~~

## Features

* Simulates a three disk setup combined together to a single drive with [mhddfs](http://manpages.ubuntu.com/manpages/trusty/man1/mhddfs.1.html).
* Installs [Plex Media Server](https://plex.tv/) - the web interface can be access by navigating your browser to [http://10.0.23.5:32400/web]().
