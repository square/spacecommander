echo ''
echo '## Setting Up OCLint ##'
echo '#######################'
brew tap oclint/formulae
brew uninstall --force oclint #> /dev/null 2>&1
brew install oclint #> /dev/null 2>&1
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
SETUP_COMPLETE_PATH="./Pods/SpaceCommander/.setup_complete.txt"
touch $SETUP_COMPLETE_PATH
echo "true" > $SETUP_COMPLETE_PATH
echo '#### Done                 #####'
echo '###############################'
