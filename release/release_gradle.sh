#!/bin/bash

# 1) Clone project from git (with submodules)
# 2) Bulild project without deploy (./gradle/gradle.sh clean build)
# 3) Replace version in gradle.properties (version = ...)
# 4) Bulild project with deploy (./gradle/gradle.sh clean uploadArchives)
# 5) Commit to git with commit message "Released version <version>"
# 6) Create a git tag with name "v<version>" (eg v4.7.0) 
# 7) Replace version in gradle.properties (version = ...)
# 8) Commit to git with commit message "Updated to <version>"
# 9) Git push and git push --tags (must specify branch name) (eg git push origin <branch>)


usage() {
  echo ""
  echo "Build, tag and release Gradle projects"
  echo "release_gradle.sh <project> <branch> <release-version> <next-version>"
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
GRADLE=./gradle/gradle.sh
GRADLE_PROPERTIES=./gradle.properties
cd $DIR

echo "---> Cleaning up previous files"
rm -rf $TMP_DIR
mkdir $TMP_DIR
cd $TMP_DIR

echo "---> Checking out project from $GIT_URL"
git clone $GIT_URL -b $BRANCH . || { error; } 

echo "---> Building Gradle project"
gradle clean build || { error; }

echo "---> Update to $RELEASE_VERSION"
sed -i "back" -e "s/^version *=.*/version = $RELEASE_VERSION/g" $GRADLE_PROPERTIES

echo "---> Building and uplade project"
gradle clean uploadArchives || { error; }

echo "---> Checking in changes to Git"
git commit -m "Updating version to $RELEASE_VERSION" -a || { error; } 

echo "---> Tagging sources with v$RELEASE_VERSION"
git tag -m "Version $RELEASE_VERSION" v$RELEASE_VERSION || { error; } 

echo "---> Updating Gradle project version to $NEXT_VERSION"
sed -i "back" -e "s/^version *=.*/version = $NEXT_VERSION/g" $GRADLE_PROPERTIES

echo "---> Building Gradle project"
gradle clean build || { error; }

echo "---> Checking in changes to Git"
git commit -m "Updating version to $NEXT_VERSION" -a || { error; } 

echo "---> Pushing changes to remote Git repository"
git push --tags origin $BRANCH || { error; } 

echo "---> Cleaning up files"
cd ..
rm -rf $TMP_DIR

