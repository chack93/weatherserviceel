#!/usr/bin/env sh

. /etc/rc.subr

name=weatherserviceel
desc="weatherserviceEl fetcher & api"
rcvar=weatherserviceel_enable

load_rc_config ${name}

: ${weatherserviceel_enable:="NO"}
: ${weatherserviceel_user:="appuser"}
: ${weatherserviceel_group:="appuser"}

pidfile="/var/run/$name/$name.pid"
command="daemon"
command_args="-r \
-u ${weatherserviceel_user} \
-o /var/log/${name}/${name}.log \
-m 3 \
-p ${pidfile} \
/usr/local/bin/bash /opt/${name}/bin/${name} foreground"
start_precmd=start_prestart
start_cmd=start_service

start_prestart() {
    if [ ! -d "/var/run/$name" ] ; then
        install -d -o "$weatherserviceel_user" -g "$weatherserviceel_group" "/var/run/$name"
    fi
}
start_service()
{
    check_startmsgs && echo "Starting ${name}."
    ${command} ${command_args}
}

run_rc_command "$1"
