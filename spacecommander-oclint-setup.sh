echo ''
echo '## Setting Up OCLint ##'
echo '#######################'
brew tap oclint/formulae > /dev/null 2>&1
brew install oclint > /dev/null 2>&1
brew link oclint > /dev/null 2>&1
oclint --version


if [[ (-z $SKIP_SPACECOMMANDER) || "$SKIP_SPACECOMMANDER" != "YES" ]]; then
	echo ''
	echo '## Setting Up SpaceCommander ##'
	echo '###############################'
	./Pods/SpaceCommander/setup-repo.sh > /dev/null 2>&1
fi

export MASTER_COMMIT_HASH=$(git rev-parse origin/master)
source Pods/SpaceCommander/lib/common-lib.sh
export CHANGED_FILES_STRING=$(objc_files_to_format $MASTER_COMMIT_HASH)
echo '#### Done                 #####'
echo '###############################'
