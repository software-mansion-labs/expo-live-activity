#!/usr/bin/env bash
set -euo pipefail

TAG=$(git describe --tags --exact-match HEAD 2>/dev/null || true)
RE='^v([0-9]+\.[0-9]+\.[0-9]+)$'

if [[ "$TAG" =~ $RE ]]; then
    NEW_VERSION="${BASH_REMATCH[1]}"

    jq --arg v "$NEW_VERSION" '.version = $v' ../package.json > package.json.tmp && mv package.json.tmp ../package.json
fi
