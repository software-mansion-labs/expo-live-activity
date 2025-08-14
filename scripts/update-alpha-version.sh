#!/usr/bin/env bash
set -euo pipefail

TAG=$(git describe --tags --exact-match HEAD 2>/dev/null || true)
RE='^alpha_v([0-9]+\.[0-9]+\.[0-9]+)\(([0-9]+)\)$'

if [[ "$TAG" =~ $RE ]]; then
    ALPHA_VERSION="${BASH_REMATCH[1]}"
    ALPHA_NUMBER="${BASH_REMATCH[2]}"
    NEW_VERSION="${ALPHA_VERSION}-alpha${ALPHA_NUMBER}"

    jq --arg v "$NEW_VERSION" '.version = $v' ../package.json > package.json.tmp && mv package.json.tmp ../package.json
fi
