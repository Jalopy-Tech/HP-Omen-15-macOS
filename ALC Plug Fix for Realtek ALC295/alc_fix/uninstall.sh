#!/bin/bash

echo "Uninstalling ALCPlugFix.  Root user is required."

sudo rm /usr/local/bin/ALCPlugFix
launchctl unload -w /Library/LaunchAgents/ALCPlugFix.plist
launchctl remove ALCPlugFix
sudo rm /Library/LaunchAgents/ALCPlugFix.plist

echo "Done!"
exit 0
