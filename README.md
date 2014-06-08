tracker_hooks
=============

Using Pivotal Tracker, and want to see your available stories when making commits?

This set of hooks will allow you to see your open stories when doing "git commit" on the command line.
By adding the story id, and desired action, you can add your commit message and finish or deliver stories.

Dependencies
------------
xsl

Getting Setup
-------------
I have tried to make it simple to get started using tracker_hooks.  You can just clone the repo, copy over the hooks to
your project .git/hooks folder and set the Pivotal Tracker project id in the .git/hooks/prepare-commit-msg file.

If you would like this process to be a bit more automated just copy the bin/hooks.sh script to your local bin directory,
make it executable and you will be able to run the script from the command line, and follow the on screen prompts.

In order for this to work you will need to generate your API token, and save it in hooks/post-commit

### How to find your Project ID ###
The Project ID is the last section of the project URL.  In the example below Project ID = 123456
ex. https://www.pivotaltracker.com/n/projects/123456