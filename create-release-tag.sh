#!/usr/bin/env bash

createTag() {
    git ls-remote --tags origin $TAG_NAME 2>/dev/null | grep $TAG_NAME 1>/dev/null
    if [ "$?" == 0 ]; then
       echo Tag $TAG_NAME already exists!;
    else
       git tag $TAG_NAME -a -m "Generated tag from TravisCI build $TRAVIS_BUILD_NUMBER"
       git push https://${GH_TOKEN}@github.com/covfefe-spikes/nodejs-release-spike.git --tags >/dev/null
    fi
}

git config --global user.email "sateeshkumar.m@gmail.com"
git config --global user.name "smathangi"
export PACKAGE_VERSION=$(jq -r ".version" package.json)
export TAG_NAME="v$PACKAGE_VERSION"

if [[ "$TRAVIS_PULL_REQUEST" != "false" && "$PACKAGE_VERSION" != *"-prerelease" ]]; then
      echo PR branch must have a prerelease version to tag
    else
     createTag
fi
