#!/usr/bin/env bash
# common-lib.sh
# shell functions which are used in several formatting scripts
# Copyright 2015 Square, Inc

IFS=$'\n'

# If the repo contains a .formatting-directory file, only files in the specified directories will be returned (one directory per line).
# If .formatting-directory doesn't exist then all files in the repository are checked.
function directories_to_check() {
	locations_to_diff=''
	[ -e ".formatting-directory" ] && locations_to_diff=$( cat .formatting-directory );
}

# Returns a list of Objective-C files to format.
# If .formatting-directory exists, then only directories specified in .formatting-directory will be included (see directories_to_check).
# No parameters: return staged ObjC files only
# Optional parameter: a git SHA. Returns a list of all ObjC files which have changed since that SHA
function objc_files_to_format() {
	optional_base_sha="$1"
	directories_to_check
	# optional_base_sha is intentionally unescaped so that it will not appear as empty quotes.
	files=$(git diff --cached --name-only $optional_base_sha --diff-filter=ACM -- $locations_to_diff | grep -e '\.m$' -e '\.mm$' -e '\.h$' -e '\.hh$')
	echo "$files" | grep -v 'Pods/' | grep -v 'Carthage/' >&1
}

# Returns a list of all Objective-C files in the git repository.
# If .formatting-directory exists, then only directories specified in .formatting-directory will be included (see directories_to_check).
function all_valid_objc_files_in_repo() {
	directories_to_check
	files=$(git ls-tree --name-only --full-tree -r HEAD -- $locations_to_diff | grep -e '\.m$' -e '\.mm$' -e '\.h$' -e '\.hh$')
	echo "$files" | grep -v 'Pods/' | grep -v 'Carthage/' >&1
}
