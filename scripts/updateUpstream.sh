#!/usr/bin/env bash

# file utilized in github actions to automatically update upstream

(
set -e
PS1="$"

current=$(cat gradle.properties | grep icecreamCommit | sed 's/icecreamCommit = //')
upstream=$(git ls-remote https://github.com/IceCreamMC/IceCream | grep ver/1.20.4 | cut -f 1)

if [ "$current" != "$upstream" ]; then
    sed -i 's/icecreamCommit = .*/icecreamCommit = '"$upstream"'/' gradle.properties
    {
      ./gradlew applyPatches --stacktrace && ./gradlew build --stacktrace && ./gradlew rebuildPatches --stacktrace
    } || exit

    git add .
    ./scripts/upstreamCommit.sh "$current"
fi

) || exit 1
