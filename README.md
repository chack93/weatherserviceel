# WSE

## Fetch dependencies
    mix deps.get

## Start server
    mix phx.server

## Create release
    mix edeliver update

## Deploy release
    mix edeliver deploy release to production

## Setup rc.d script
copy rc_scripts/weatherserviceel to /etc/rc.d/weatherserviceel
__LOCAL:__
    scp ./rc_scripts/weatherserviceel e_runtime_jail:.

__ROOT:__
    cp /home/appuser/weatherserviceel /etc/rc.d/weatherserviceel
    echo 'weatherserviceel_enable="YES"' >> /etc/rc.conf
    pkg install bash
    cp /usr/local/bin/bash /bin/bash
