#!/usr/bin/env bash
# common-lib.sh
# shell functions which are used in several formatting scripts
# Copyright 2015 Square, Inc

IFS=$'\n'

# Returns a list of Objective-C files to format.
# No parameters: return staged ObjC files only
# Optional parameter: a git SHA. Returns a list of all ObjC files which have changed since that SHA
# 
# If the repo contains a .formatting-directory file, only files in the specified directory will be returned.
function objc_files_to_format() {
	optional_base_sha="$1"

	location_to_diff=''
	[ -e ".formatting-directory" ] && location_to_diff=$( cat .formatting-directory );

	# optional_base_sha is intentionally unescaped so that it will not appear as empty quotes.
	files=$(git diff --cached --name-only $optional_base_sha --diff-filter=ACM -- "$location_to_diff" | grep -e '\.m$' -e '\.mm$' -e '\.h$' -e '\.hh$')
	echo "$files" | grep -v 'Pods/' | grep -v 'Carthage/' >&1
}

# Returns a list of all Objective-C files in the git repository.
# If the repo contains a .formatting-directory file, only files in the specified directory will be returned.
function all_valid_objc_files_in_repo() {
	location_to_diff=''
	[ -e ".formatting-directory" ] && location_to_diff=$( cat .formatting-directory );

	files=$(git ls-tree --name-only --full-tree -r HEAD -- "$location_to_diff" | grep -e '\.m$' -e '\.mm$' -e '\.h$' -e '\.hh$')
	echo "$files" | grep -v 'Pods/' | grep -v 'Carthage/' >&1
}
