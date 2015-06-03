#!/usr/bin/env bash
# ~/.git_template.local/hooks/pre-commit
# format-objc-hook
# pre-commit hook to check if any unformatted Objective-C files would be committed. Fails the check if so, and provides instructions.
#
# Copyright 2015 Square, Inc

IFS=$'\n'
export CDPATH=""
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR"/lib/common-lib.sh

# Don't do anything unless a .clang-format file exists
[ -e ".clang-format" ] || exit 0

objc_files=$(objc_files_to_format "$1")
[ -z "$objc_files" ] && exit 0

function format_objc() {
  success=0
  for file in $objc_files; do
	difference=$("$DIR"/format-objc-file-dry-run.sh "$file" | diff "$file" - | wc -l)
	
    if [ $difference -gt 0 ]; then
    	# This is what the dev can run to fixup an individual file
    	echo "$DIR/format-objc-file.sh '$file' && git add '$file';"
    	success=1
    fi
  done
  return $success 
}

success=0
format_objc || (echo -e "🔴  There were formatting issues with this commit, fix by running the👆 above👆 commands. \n\tYou can also run: $DIR/format-objc-files.sh\n💔  Commit anyway and skip this check by running git commit --no-verify" && success=1)

exit $success
