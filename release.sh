#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
RELEASE_DIR='release';

if [ -z "$1" ]
	then
		echo "Error: Must pass version string (e.g. v1.2.3) as first parameter.";
		exit 0;
fi

echo "Releasing version $1";

if [ -d "$SCRIPT_DIR/release" ] && [ ! -d "$SCRIPT_DIR/release/.git" ]
	then
		# Cleanup and clone fresh copy of repo on build branch.
		rm -r "$SCRIPT_DIR/$RELEASE_DIR";
		git clone --recursive --branch build git@github.com:humanmade/hm-gutenberg-tools.git ${RELEASE_DIR}
	else
		# Cleanup any changes and reset to build branch.
		cd "${SCRIPT_DIR}/${RELEASE_DIR}";
		git clean -fd;
		git reset origin/build --hard;
fi

# Merge in latest from master, install dependencies and build.
cd "${SCRIPT_DIR}/${RELEASE_DIR}";
git merge origin/master --no-edit;
npm install;
npm run build;

# Stage changes ready for commit.
git add .;
git add -f build;

# Commit to build branch and tag release.
git commit -m "Release $1";
git tag ${1};
git push origin build;
git push --tags;
