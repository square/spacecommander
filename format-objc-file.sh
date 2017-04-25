#!/usr/bin/env bash
# format-objc-file.sh
# Formats an Objective-C file, replacing it without a backup.
# Copyright 2015 Square, Inc

export CDPATH=""
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ ! -e ".clang-format" ]; then
	echo "Couldn't find .clang-format file, unable to format files. Please setup this repo by running the setup-repo.sh script from your repo's top level."
	echo "Also, formatting scripts should be run from the repo's top level dir."
	exit 1
fi

function format_objc_file_dry_run() {
  # "#pragma Formatter Exempt" or "// MARK: Formatter Exempt" means don't format this file.
  # Read the first line and trim it.
  line="$(head -1 "$1" | xargs)" 
  if [ "$line" == "#pragma Formatter Exempt" -o "$line" == "// MARK: Formatter Exempt" ]; then
    cat "$1" 
    return;
  fi

  cat "$1" | \
  # Fix an edge case with array / dictionary literals that confuses clang-format
  python "$DIR"/custom/LiteralSymbolSpacer.py | \
  # The formatter gets confused by C++ inline constructors that are broken onto multiple lines
  python "$DIR"/custom/InlineConstructorOnSingleLine.py | \
  # Add a semicolon at the end of simple macros
  python "$DIR"/custom/MacroSemicolonAppender.py | \
  # Add an extra newline before @implementation and @interface
  python "$DIR"/custom/DoubleNewlineInserter.py | \
  # Run clang-format
  "$DIR"/bin/clang-format-3.8-custom -style=file | \
  # Fix an issue with clang-format getting confused by categories with generic expressions.
  python "$DIR"/custom/GenericCategoryLinebreakIndentation.py | \
  # Fix an issue with clang-format breaking up a lone parameter onto a newline after a block literal argument.
  python "$DIR"/custom/ParameterAfterBlockNewline.py | \
  # Fix an issue with clang-format inserting spaces in a preprocessor macro.
  python "$DIR"/custom/HasIncludeSpaceRemover.py | \
  # Add a newline at the end of the file
  python "$DIR"/custom/NewLineAtEndOfFileInserter.py
}

function format_objc_file() {
  tempFile=$1".tmp"
  format_objc_file_dry_run "$1" >"$tempFile"
  mv $tempFile $1  
}

if [ "$2" == "-d" ]; then
  format_objc_file_dry_run "$1"
else
  format_objc_file "$1"
fi
