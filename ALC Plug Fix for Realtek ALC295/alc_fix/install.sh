#!/bin/bash

echo "Installing ALCPlugFix.  Root user is required."

# copy over the files to their respective locations (overwrite automatically if files exist)
sudo cp -f ALCPlugFix /usr/local/bin
sudo chmod 755 /usr/local/bin/ALCPlugFix

sudo cp -f hda-verb /usr/local/bin
sudo chmod 755 /usr/local/bin/hda-verb


sudo cp -f ALCPlugFix.plist /Library/LaunchAgents
sudo chmod 644 /Library/LaunchAgents/ALCPlugFix.plist


# load and start the daemon
launchctl load -w /Library/LaunchAgents/ALCPlugFix.plist


# output status
echo "Current status:"
sudo launchctl list | grep ALCPlugFix


echo "Done!"
exit 0
