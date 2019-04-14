#!/usr/bin/env sh

DIR="$( cd "$( dirname "$0" )" && pwd )"
VERSION=`sed -nE 's/^( )*version:( )?( )?.?//p' "${DIR}/mix.exs" | sed 's/..$//'`
APP=weatherserviceel

echo "\n--- BUILD ---\n"
# build
mix deps.get --only prod
mix clean
MIX_ENV=prod mix release

# package
echo "\n--- PACKAGE ---\n"
rm -f "$APP-*.tar.gz"
rm -rf "/tmp/$APP-$VERSION"
mkdir -p "/tmp/$APP-$VERSION"
cp -r ${DIR}/tarball-base/* "/tmp/$APP-$VERSION/."
cp -r "$DIR/_build/prod/rel/$APP" "/tmp/$APP-$VERSION/$APP"
cd /tmp
tar -cvf "$APP-$VERSION.tar.gz" "$APP-$VERSION"
cd ${DIR}
mv "/tmp/$APP-$VERSION.tar.gz" "$DIR/."
rm -rf "/tmp/$APP-$VERSION"

echo "\n--- DONE ---\n"
