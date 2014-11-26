#!/bin/bash

# install plex server
apt-get install -y avahi-daemon avahi-utils
wget --quiet --output-document /tmp/plexmediaserver.deb "https://downloads.plex.tv/plex-media-server/0.9.11.1.678-c48ffd2/plexmediaserver_0.9.11.1.678-c48ffd2_amd64.deb"
dpkg -i /tmp/plexmediaserver.deb
usermod -aG users plex

exit 0
