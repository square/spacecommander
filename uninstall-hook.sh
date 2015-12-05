#!/usr/bin/env bash
# uninstall-hook.sh
# Used to reverse the modifications made for the pre-commit hook by setup-repo.sh
# Copyright 2015 Square, Inc

set -ex

pre_commit_file='.git/hooks/pre-commit'

if [[ ! -d ".git" && -e ".git" ]]; then
  # grab the git dir from our .git file, listed as 'gitdir: blah/blah/foo'
  git_dir=$(grep gitdir .git | cut -d ' ' -f 2)
  pre_commit_file="$git_dir/hooks/pre-commit"
fi

echo "Deleting from: ${pre_commit_file}"

sed '/# SPACE COMMANDER START #/,/# SPACE COMMANDER END #/d' "${pre_commit_file}" > "${pre_commit_file}-uninstalled"
mv "${pre_commit_file}-uninstalled" "${pre_commit_file}"
