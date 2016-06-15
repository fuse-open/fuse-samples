#!/bin/bash
set -e

if [ $# -ne 3 ]; then
    echo $*
    echo "USAGE: $0 <download directory> <ci server url> <ci server atuhorization>"
    exit 1
fi

BRANCH_URL=http://fusereleasebranch.azurewebsites.net/release
BRANCH=$(curl $BRANCH_URL)
FUSE_DIR=$1
CI_SERVER_URL="$2"
CI_SERVER_AUTH="Authorization: Basic $3"
if [ "$OSTYPE" == "msys" ] ; then
    OS="Windows"
else
    OS="OSX"
fi

if [ ${#FUSE_DIR} -lt 3 ]; then
    echo "Oooh, scary! FUSE_DIR is '$FUSE_DIR', that sounds like an error. I don't dare to delete that directory"
    exit 2
fi

BRANCH=$(echo $BRANCH | sed 's/\//%2F/')
echo "Branch is $BRANCH"
BUILD_ID_URL="$CI_SERVER_URL/builds?locator=project:Fuse,buildType:(id:Fuse_BuildFor$OS),branch:$BRANCH,count:1,status:SUCCESS"

echo "Looking up build id at $BUILD_ID_URL"
BUILD_ID=$(curl -s --header "$CI_SERVER_AUTH" $BUILD_ID_URL | sed 's/.*build id="\([0-9]*\)".*/\1/')
echo "BUILD_ID is: '$BUILD_ID'"

ARTIFACTS_URL="https://tc.outracks.com/httpAuth/app/rest/builds/$BUILD_ID/artifacts"
echo "Looking up artifacts at $ARTIFACTS_URL"
ARTIFACTS=$(curl -s --header "$CI_SERVER_AUTH" $ARTIFACTS_URL)
echo "Artifacts are: '$ARTIFACTS'"

ZIP=$CI_SERVER_URL"/"$(echo $ARTIFACTS | grep 'content/Fuse.*zip' | sed 's/.*\(builds.*zip\).*/\1/')
echo "Downloading "$ZIP

rm -rf $FUSE_DIR
mkdir -p $FUSE_DIR
cd $FUSE_DIR
curl -s -O --header "$CI_SERVER_AUTH" $ZIP
unzip -q *.zip
