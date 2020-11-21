#!/usr/bin/env bash
# format-objc-file.sh
# Formats an Objective-C file, replacing it without a backup.
# Copyright 2015 Square, Inc

set -o errexit
set -o nounset
set -o pipefail

export CDPATH=""
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DRY_RUN=0
FILE=""

function help() {
	echo "$0 - formats an objc file"
	echo " "
	echo "$0 [options] file"
	echo " "
	echo "options:"
	echo "-h, --help     show brief help"
	echo "-d, --dry-run  output formatted file to STDOUT, instead of modifying it"
}

while test $# -gt 0; do
	case "$1" in
	-h | --help)
		help
		exit 0
		;;
	-d | --dry-run)
		DRY_RUN=1
		shift
		;;
	*)
		if [ -n "$FILE" ]; then
			echo "May only provide a single file"
			help
			exit 1
		fi
		FILE="$1"
		shift
		;;
	esac
done

if [ ! -e ".clang-format" ]; then
	echo "Couldn't find .clang-format file, unable to format files. Please setup this repo by running the setup-repo.sh script from your repo's top level."
	echo "Also, formatting scripts should be run from the repo's top level dir."
	exit 1
fi

if [ ! -n "$FILE" ]; then
	echo "Must provide a file to format"
	help
	exit 1
fi

function format_objc_file_dry_run() {
	# "#pragma Formatter Exempt" or "// MARK: Formatter Exempt" means don't format this file.
	# Read the first line and trim it.
	line="$(head -1 "$FILE" | xargs)"
	if [ "$line" == "#pragma Formatter Exempt" -o "$line" == "// MARK: Formatter Exempt" ]; then
		cat "$1"
		return
	fi

	cat "$1" |
		/usr/bin/python3 "$DIR"/custom/LiteralSymbolSpacer.py |
		/usr/bin/python3 "$DIR"/custom/InlineConstructorOnSingleLine.py |
		/usr/bin/python3 "$DIR"/custom/MacroSemicolonAppender.py |
		/usr/bin/python3 "$DIR"/custom/DoubleNewlineInserter.py |
		"$DIR"/bin/clang-format-12.0.0-244022a3cd75b51dcf1d2a5a822419492ce79e47 -style=file |
		/usr/bin/python3 "$DIR"/custom/GenericCategoryLinebreakIndentation.py |
		/usr/bin/python3 "$DIR"/custom/ParameterAfterBlockNewline.py |
		/usr/bin/python3 "$DIR"/custom/HasIncludeSpaceRemover.py |
		/usr/bin/python3 "$DIR"/custom/NewLineAtEndOfFileInserter.py
}

function format_objc_file() {
	tempFile="$(mktemp)"
	status=0
	format_objc_file_dry_run "$1" >"$tempFile" || status=$?
	if [ $status -eq 0 ]; then
		mv "$tempFile" "$1"
	else
		rm -f "$tempFile"
		exit $status
	fi
}

if [ $DRY_RUN -eq 0 ]; then
	format_objc_file "$FILE"
else
	format_objc_file_dry_run "$FILE"
fi
