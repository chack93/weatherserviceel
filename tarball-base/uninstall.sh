#!/usr/bin/env sh

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPNAME=weatherserviceel
VERSION=`echo $(basename "$DIR/$APPNAME-*.jar") | sed -En "s/^.*$APPNAME-//p" | sed -En 's/.jar$//p'`
INSTALLDIR="/opt/$APPNAME"
LOGDIR="/var/log/$APPNAME"
RC_CONFIG="/etc/rc.d/$APPNAME"

# remove rc.conf
serivce ${APPNAME} stop
rm -f ${RC_CONFIG}
sed -i.bak s/"${APPNAME}_enable=\"YES\""//g /etc/rc.conf

# remove app
rm -rf${INSTALLDIR}
rm -f "/usr/local/etc/newsyslog.conf.d/$APPNAME.conf"
