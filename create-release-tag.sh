#!/bin/bash

git config --global user.email "sateeshkumar.m@gmail.com"
git config --global user.name "smathangi"
git fetch --tags
export GIT_TAG=$(jq -r ".version" package.json)

if [ "$TRAVIS_PULL_REQUEST" == "true" ] && [ "$GIT_TAG" != "*-prerelease" ]; then
    echo "PULL REQUEST must have a prerelease version to tag"
    exit
fi
if git tag v$GIT_TAG -a -m "Generated tag from TravisCI build $TRAVIS_BUILD_NUMBER" 2>/dev/null; then
    git push https://${GH_TOKEN}@github.com/covfefe-spikes/nodejs-release-spike.git --tags
  else
    echo Tag v$GIT_TAG already exists!
fi