#!/usr/bin/env bash

# requires curl & jq

# upstreamCommit <baseHash>
# param: bashHash - the commit hash to use for comparing commits (baseHash...HEAD)

(
set -e
PS1="$"

icecream=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/IceCreamMC/IceCream/compare/$1...ver/1.20.4 | jq -r '.commits[] | "IceCreamMC/IceCream@\(.sha[:7]) \(.commit.message | split("\r\n")[0] | split("\n")[0])"')

updated=""
logsuffix=""
if [ ! -z "$icecream" ]; then
    logsuffix="$logsuffix\n\nIceCream Changes:\n$IceCream"
    updated="IceCream"
fi
disclaimer="Upstream has released updates that appear to apply and compile correctly"

log="${UP_LOG_PREFIX}Updated Upstream ($updated)\n\n${disclaimer}${logsuffix}"

echo -e "$log" | git commit -F -

) || exit 1
