#!/usr/bin/env sh

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPNAME=weatherserviceel
VERSION=`echo $(basename "$DIR/$APPNAME-*.jar") | sed -En "s/^.*$APPNAME-//p" | sed -En 's/.jar$//p'`
INSTALLDIR="/opt/$APPNAME"
LOGDIR="/var/log/$APPNAME"
RC_CONFIG="/etc/rc.d/$APPNAME"

# create app user & group
if [ ! `id -u appuser > /dev/null 2>&1` ]
then
  echo "Adding user & group: appuser"
  if [ ! `getent group appuser` ]
  then
    pw groupadd appuser
  fi
  pw useradd -n appuser -G appuser -m -w none
fi

# copy app
echo "Copying app & set file owner"
mkdir -p ${INSTALLDIR}
cp -r ${DIR}/${APPNAME}/* ${INSTALLDIR}
chmod -R 770 "$INSTALLDIR"
if [ ! -f "$INSTALLDIR/config.exs" ]; then
  cp "$DIR/config.exs" ${INSTALLDIR}
  chmod -R 770 "$INSTALLDIR/config.exs"
fi
chown -R root:appuser ${INSTALLDIR}

# install dependencies
if [ ! -x "$(command -v bash)" ]
then
    echo "Installing bash"
    pkg install bash
fi

# config files
echo "Setup rc.conf file & newsyslog"
cp "$DIR/$APPNAME.sh" ${RC_CONFIG}
chmod -R 555 ${RC_CONFIG}
mkdir -p ${LOGDIR}
chown appuser:appuser ${LOGDIR}
mkdir -p /usr/local/etc/newsyslog.conf.d
echo "$LOGDIR/$APPNAME.log appuser:appuser 660 7 * @T00 CJN" > "/usr/local/etc/newsyslog.conf.d/$APPNAME.conf"

service ${APPNAME} onerestart

echo "Service running at Port: 8080"
echo "To start the service at startup run:

echo ${APPNAME}_enable=\\\"YES\\\" >> /etc/rc.conf

"
