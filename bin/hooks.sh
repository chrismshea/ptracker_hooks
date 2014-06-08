#!/bin/bash

##
## Description: This script is used to setup your current repo with hooks that will allow you to connect to tracker.
## Author: Chris Shea
## Last Updated: 6/8/2014
##


## Establishing the location of the directory containing the git repo for your project.
if (! PROJECT_DIR=$(git rev-parse --show-toplevel)) 2> /dev/null;
then
    read -p "Enter the path to your project DIR containing the git repo: " PROJECT_DIR
    echo "Project DIR: $PROJECT_DIR"
else
    PROJECT_DIR=$(git rev-parse --show-toplevel)
    echo "Project DIR: $PROJECT_DIR"
fi


## Ask for the Users API Token
if [[ ! -f ~/.pivotaltoken ]];
    then
        echo "We did not find your Pivotal Tracker API Token"
        read -p "Pleae enter your API Token: " PIVOTAL_TOKEN
        echo "$PIVOTAL_TOKEN" > ~/.pivotaltoken
    else
        PIVOTAL_TOKEN=`cat ~/.pivotaltoken`
        echo "API Token: $PIVOTAL_TOKEN"
fi


## Getting the ID for the Pivotal Tracker projec.
PROJECT=""
while [ "$PROJECT" = "" ]; do
	read -p "Project ID: " PROJECT
done


## Checking if the tracker_hooks repo exists, otherwise cloning it.
read -p "Enter full path to the tracker_hooks repo directory: " DIRECTORY
if [ -d "$DIRECTORY" ]; then
    # Tracker hooks exists
    echo "Tracker Hooks repo exists updating master branch."
    git --git-dir="$DIRECTORY/.git" checkout master
    git pull origin master
else
    # Clone the repo
    echo "Cloning the tracker_hooks repo"
    git clone git@github.com:chrismshea/tracker_hooks.git $DIRECTORY
fi


## Copy the tracker hooks from the tracker_hooks repo to your project .git/hooks" ##
echo "Copy tracker hooks to your .git/hooks dir."
rsync -r ~/src/tracker_hooks/hooks/ $PROJECT_DIR/.git/hooks/
echo "Saving your project id in the .git/hooks/prepare-commit-msg hook"
sed -i '' "s/\[PROJECT\]/$PROJECT/g" $PROJECT_DIR/.git/hooks/prepare-commit-msg
chmod +x $PROJECT_DIR/.git/hooks/*
echo "Successfully copied over the hooks. You can view/edit these in your .git/hooks directory"


## Setup the post-commit hook with the Pivotal Tracker API Token
sed -i '' "s/\[PIVOTAL_TOKEN\]/$PIVOTAL_TOKEN/g" $PROJECT_DIR/.git/hooks/prepare-commit-msg $PROJECT_DIR/.git/hooks/post-commit

## Complete Message ##
echo "Now when running 'git commit' you will see a list of stories and instructions for attributing commits!"