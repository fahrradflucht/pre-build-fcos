#!/bin/bash

set -e

get_latest_release_tag() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" |
    jq -r .tag_name
}

get_latest_crate_version_num() {
  curl --silent "https://crates.io/api/v1/crates/$1" |
    jq -r '.versions | map(.num) | sort | last'
}

LATEST_RELEASE_TAG="$(get_latest_release_tag mathiswiehl/pre-build-fcos)"
LATEST_CRATE_VERSION_NUM="$(get_latest_crate_version_num coreos-installer)"

LATEST_CRATE_TAG="v$LATEST_CRATE_VERSION_NUM"

if [ "$LATEST_CRATE_TAG" = "$LATEST_RELEASE_TAG" ]; then
  echo "Release is already up-to-date."
else
  echo "New version $LATEST_CRATE_TAG available. Latest release was $LATEST_RELEASE_TAG. Building..."
  VERSION="$LATEST_CRATE_VERSION_NUM" make coreos-installer

  git config --local user.name "mathiswiehl"
  git config --local user.email "mathis.wiehl@jimdo.com"

  export TRAVIS_TAG="$LATEST_CRATE_TAG"
  git tag "$TRAVIS_TAG"
fi
