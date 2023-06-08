#!/bin/bash

# This script downloads and installs the devel branch of yabsm.

set -e

SCRIPT=${0##*/}

if [[ $(id -u) != 0 ]]; then
    echo "$SCRIPT: $SCRIPT must be run by the root user. Exiting." >&2
    exit 1
fi

git clone -b devel https://github.com/NicholasBHubbard/yabsm.git

yabsm/yabsm-install

rm -rf yabsm
