#!/usr/bin/env bash
# compile-time-check.sh
# Use this script to fail the build at compile time if *any* formatting issues exist (git status doesn't matter). 
# Copyright 2015 Square, Inc

IFS=$'\n'
export CDPATH=""
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR"/lib/common-lib.sh

[ -e ".clang-format" ] || { echo -e "\n🔴  Expected .clang-format file. Add one or run \"$DIR\"/setup-repo.sh\n from top-level repo." && exit 1; }

objc_files=$(all_valid_objc_files_in_repo)
[ -z "$objc_files" ] && exit 0

function format_objc() {
  success=0
  for file in $objc_files; do
    difference=$("$DIR"/format-objc-file-dry-run.sh "$file" | diff "$file" - | wc -l)
	
    if [ $difference -gt 0 ]; then
        if [ $success -eq 0 ]; then
            echo -e "🚸 Format and stage individual files:"
        fi
    	# This is what the dev can run to fixup an individual file
    	echo "\"$DIR\"/format-objc-file.sh '$file' && git add '$file';"
    	success=1
    fi
  done
  if [ $success -gt 0 ]; then
      echo -e "\n🚀  Format all files:\n\t \"$DIR\"/format-objc-files-in-repo.sh"
  fi
  return $success 
}

format_objc || { echo -e "\n🔴  There were formatting issues with this commit, run the👆 above👆 command to fix.\n" && exit 1; }

exit 0
