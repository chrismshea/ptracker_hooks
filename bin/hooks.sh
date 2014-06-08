#!/bin/bash

##
## Description: This script is used to setup your current repo with hooks that will allow you to connect to tracker.
## Author: Chris Shea
## Last Updated: 6/8/2014
##

## TO Do: Setup API Token

## Establishing the project folder ##
PROJECT_FOLDER=$(git rev-parse --show-toplevel)
echo "Project Folder: $PROJECT_FOLDER"

## Getting the ID for the Pivotal Tracker project ##
PROJECT=""
while [ "$PROJECT" = "" ]; do
	read -p "Project ID: " PROJECT
done

## Checking if the tracker_hooks repo exists, otherwise cloning it. ##
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
echo "Copying over the hooks from the tracker_hooks repo"
rsync -r ~/src/tracker_hooks/hooks/ $PROJECT_FOLDER/.git/hooks/
sed -i '' "s/\[PROJECT\]/$PROJECT/g" $PROJECT_FOLDER/.git/hooks/prepare-commit-msg
chmod +x $PROJECT_FOLDER/.git/hooks/*
echo "Successfully copied over the hooks. You can view/edit these in your .git/hooks directory"

## Complete Message ##
echo "Now when running 'git commit' you will see a list of stories and instructions for attributing commits!"