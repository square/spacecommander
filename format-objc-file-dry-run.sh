#!/usr/bin/env bash
# format-objc-file-dry-run.sh
# Outputs a formatted Objective-C file to stdout (doesn't alter the file).
# Copyright 2015 Square, Inc

set -eu

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
exec "$DIR"/format-objc-file.sh --dry-run "${@}"
