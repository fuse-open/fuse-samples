#!/bin/bash
set -e

if [ $# -ne 4 ]; then
    echo $*
    echo "USAGE: $0 <file containing fuse branch name> <download directory> <ci server url> <ci server atuhorization>"
    exit 1
fi


BRANCH=$(cat $1)
FUSE_DIR=$2
CI_SERVER_URL="$3"
CI_SERVER_AUTH="Authorization: Basic $4"
if [ "$OSTYPE" == "msys" ] ; then
    OS="Windows"
else
    OS="OSX"
fi

if [ ${#FUSE_DIR} -lt 3 ]; then
    echo "Oooh, scary! FUSE_DIR is '$FUSE_DIR', that sounds like an error. I don't dare to delete that directory"
    exit 2
fi

echo "Branch is $BRANCH"
URL="$CI_SERVER_URL/builds/project:Fuse,buildType:(id:Fuse_BuildFor$OS),branch:$BRANCH,count:1/artifacts"

echo "Looking up artifacts at $URL"
ARTIFACTS=$(curl -s --header "$CI_SERVER_AUTH" $URL)
echo "Artifacts are: '$ARTIFACTS'"

ZIP=$CI_SERVER_URL"/"$(echo $ARTIFACTS | grep 'content/Fuse.*zip' | sed 's/.*\(builds.*zip\).*/\1/')
echo "Downloading "$ZIP

rm -rf $FUSE_DIR
mkdir -p $FUSE_DIR
cd $FUSE_DIR
curl -s -O --header "$CI_SERVER_AUTH" $ZIP
unzip -q *.zip
