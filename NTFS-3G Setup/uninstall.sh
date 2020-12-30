#!/bin/bash

echo "Uninstalling ntfs-3g-mount.  Root user is required."

sudo rm /usr/local/bin/ntfs-3g-mount
sudo launchctl unload -w /Library/LaunchDaemons/ntfs-3g-mount.plist
launchctl remove ntfs-3g-mount
sudo rm /Library/LaunchDaemons/ntfs-3g-mount.plist

echo "Done!"
exit 0
