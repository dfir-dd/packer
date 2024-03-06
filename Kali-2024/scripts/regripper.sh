#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ ! -x /usr/local/bin/rip ] ; then   
    yes | apt install -yq perl-doc

    mkdir /opt/RegRipper3.0
    git clone https://github.com/keydet89/RegRipper3.0.git /opt/RegRipper3.0
    cd /opt/RegRipper3.0
    sed -i 's/catfile("plugins")/catfile($str,"plugins")/' rip.pl

    yes | cpan install Parse::Win32Registry
    cp *.pm $(echo `perldoc -l Parse::Win32Registry` |sed 's/\\.pm//')/WinNT/

    echo '#!/bin/bash' >/usr/local/bin/rip
    echo 'PERL5LIB=/opt/RegRipper3.0 perl /opt/RegRipper3.0/rip.pl $@' >>/usr/local/bin/rip
    chmod 755 /usr/local/bin/rip
fi