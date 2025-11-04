#!/bin/zsh
###############################################################
#
## Copyright (©) 2024-2025 David H Hoyt. All rights reserved.
##                 https://srd.cx
##
## Last Updated: 04-NOV-2025 1400Z by David Hoyt
#
## Intent: Check Set Code Page on Unix in zsh
#
## TODO: add sh, bash too
#
#
#
#
#
#
#
#
###############################################################

# Detect OS
case "$(uname)" in
    Darwin)
        os="macOS"
        ;;
    Linux)
        os="Linux"
        ;;
    *)
        os="Unknown"
        ;;
esac

echo "Detected OS: $os"

# Determine available UTF-8 locale
if locale -a 2>/dev/null | grep -qi "en_US.utf8"; then
    export LANG=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
else
    echo "en_US.UTF-8 not found; using C.UTF-8 fallback."
    export LANG=C.UTF-8
    export LC_CTYPE=C.UTF-8
fi

echo "UTF-8 encoding environment configured."
locale
