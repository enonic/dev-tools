#!/bin/bash

# 1) Clone project from git (with submodules)
# 2) Build project without deploy (mvn clean install)
# 3) Run mvn versions:set to set version to release-version
# 4) Run mvn versions:commit to remove temporary version
# 5) Bulild project with deploy (mvn clean deploy)
# 6) Commit to git with commit message "Released version <version>"
# 7) Create a git tag with name "v<version>" (eg v4.7.0) 
# 8) Run mvn versions:set to set version to next-version
# 9) Run mvn versions:commit to remove temporary version
# 10) Commit to git with commit message "Updated to <version>"
# 11) Git push and git push --tags (must specify branch name) (eg git push origin <branch>)

usage() {
  echo ""
  echo "Build, tag and release Maven projects"
  echo "release_maven.sh <project> <branch> <release-version> <next-version>"
  echo ""
  exit 1
}

error() {
  echo "---> ERROR! Failed to complete release"
  exit 1
}

[ "$#" -eq 4 ] || usage

DIR=`dirname $0`
PROJECT=$1
BRANCH=$2
RELEASE_VERSION=$3
NEXT_VERSION=$4
GIT_URL=git@github.com:enonic/$PROJECT.git
TMP_DIR=./stage

cd $DIR

echo "---> Cleaning up previous files"
rm -rf $TMP_DIR
mkdir $TMP_DIR
cd $TMP_DIR

echo "---> Checking out project from $GIT_URL"
git clone $GIT_URL -b $BRANCH . || { error; } 

echo "---> Building Maven project"
mvn clean install || { error; }

echo "---> Set release version: $RELEASE_VERSION"
mvn versions:set -DnewVersion=$RELEASE_VERSION || { error; }

echo "---> Confirm version: $RELEASE_VERSION"
mvn versions:commit || { error; }

echo "---> Building Maven project"
mvn clean deploy || { error; }

echo "---> Checking in changes to Git"
git commit -m "Updating version to $RELEASE_VERSION" -a || { error; } 

echo "---> Tagging sources with v$RELEASE_VERSION"
git tag -m "Version $RELEASE_VERSION" v$RELEASE_VERSION || { error; } 

echo "---> Updating Maven project version to $NEXT_VERSION"
mvn versions:set -DnewVersion=$NEXT_VERSION || { error; }

echo "---> Confirm version: $NEXT_VERSION"
mvn versions:commit || { error; }

echo "---> Building Maven project"
mvn clean install || { error; }

echo "---> Checking in changes to Git"
git commit -m "Updating version to $NEXT_VERSION" -a || { error; } 

echo "---> Pushing changes to remote Git repository"
git push --tags origin $BRANCH || { error; } 

echo "---> Cleaning up files"
cd ..
rm -rf $TMP_DIR
