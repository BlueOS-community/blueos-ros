#!/usr/bin/env bash

# Immediately exit on errors
set -e

LOCAL_BINARY_PATH="/usr/bin/ttyd"
VERSION=1.7.3

# By default we install armv7
REMOTE_BINARY_URL="https://github.com/tsl0922/ttyd/releases/download/${VERSION}/ttyd.armhf"
if [[ "$(uname -m)" == "x86_64"* ]]; then
    REMOTE_BINARY_URL="https://github.com/tsl0922/ttyd/releases/download/${VERSION}/ttyd.x86_64"
fi

wget "$REMOTE_BINARY_URL" -O "$LOCAL_BINARY_PATH"
chmod +x "$LOCAL_BINARY_PATH"