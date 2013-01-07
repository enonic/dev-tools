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
