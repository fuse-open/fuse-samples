#!/bin/bash
set -e

usage_and_die()
{
    echo "USAGE: $0 build|preview <target> <ci server url> <ci server atuhorization>"
    exit 1
}

if [ $# -ne 4 ]; then
    usage_and_die
fi

BASEDIR=$(dirname $BASH_SOURCE)
ROOTDIR=$( cd $BASEDIR/../.. ; pwd)
FUSEDIR=$ROOTDIR/FuseDownloaded
BUILDER=$ROOTDIR/./tools/Stuff/MultiProjBuilder/MultiProjBuilder.exe
PROJECT_DIR=$ROOTDIR/Samples
EXCLUDES=(NativeDialogs/Fuse.Dialogs)
ACTION=$1
TARGET=$2
CI_SERVER_URL=$3
CI_SERVER_AUTH=$4

echo $ACTION"ing for "$TARGET
echo "ROOTDIR is '$ROOTDIR'"
echo "FUSEDIR is '$FUSEDIR'"

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Using mono"
    MONO=mono
else
    echo "Not using mono"
    MONO=""
fi

EXCLUDE_ARGS=" "
if [ ${#EXCLUDES[@]} -gt 0 ]; then
    for e in ${EXCLUDES[@]}; do
        EXCLUDE_ARGS="$EXCLUDE_ARGS -e $PROJECT_DIR/$e"
    done
    echo "Excluding using '$EXCLUDE_ARGS'"
fi

echo "Installing stuff"
pushd $ROOTDIR/tools/Stuff
$MONO ./stuff.exe install .
popd

echo "Getting Fuse"
$ROOTDIR/tools/CI/get-fuse.sh $FUSEDIR $CI_SERVER_URL $CI_SERVER_AUTH

echo "Setting paths"
if [ "$MONO" != "" ]; then 
    sed -i '' "s+ Packages+ $FUSEDIR/Packages+" $FUSEDIR/Fuse.app/Contents/Fuse.unoconfig
    sed -i '' "s+.*/usr/local/share/uno/Packages++" $FUSEDIR/Fuse.app/Contents/Fuse.unoconfig
    sed -i '' "s+InstallDirectory:.*+InstallDirectory: InstalledPackages+" $FUSEDIR/Fuse.app/Contents/Fuse.unoconfig
    sed -i '' "s+\([a-zA-Z]*\.packages\)+../../\1+" $FUSEDIR/Fuse.app/Contents/Fuse.unoconfig
    echo -n "/Library/Frameworks/Mono.framework/Versions/Current" > $FUSEDIR/Fuse.app/Contents/.mono_root
    UNO=$FUSEDIR/Fuse.app/Contents/Uno/uno.exe
    FUSE=$FUSEDIR/Fuse.app/Contents/MacOS/Fuse
else
    PACKAGES=$(echo $FUSEDIR | sed 's/^..//')"/Packages"
    echo "PACKAGES is $PACKAGES"
    sed -i'' "s+ Packages+ $PACKAGES+" $FUSEDIR/Fuse.unoconfig
    sed -i'' "s+.*PROGRAMDATA.*++" $FUSEDIR/Fuse.unoconfig
    sed -i'' "s+InstallDirectory:.*+InstallDirectory: InstalledPackages+" $FUSEDIR/Fuse.unoconfig
    UNO=$FUSEDIR/uno.exe
    FUSE=$FUSEDIR/Fuse.exe
    echo ""
fi

echo "Bulding examples"
if [ $ACTION == "build" ]; then
    $MONO $BUILDER -b $UNO -a "build -v --trace --target=$TARGET" $PROJECT_DIR $EXCLUDE_ARGS
elif [ $ACTION == "preview" ]; then
    if [ "$TARGET" == "local" ]; then
        $MONO $BUILDER -b $FUSE -a "host-preview --compile-only" $PROJECT_DIR $EXCLUDE_ARGS
    else
        $MONO $BUILDER -b $FUSE -a "preview --compile-only --target=$TARGET" $PROJECT_DIR $EXCLUDE_ARGS
    fi
else
    echo "Invalid action '$ACTION'"
    exit 1
fi
