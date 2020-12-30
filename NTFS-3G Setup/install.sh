#!/bin/bash

echo "Installing ntfs-3g-mount.  Root user is required."

# copy over the files to their respective locations (overwrite automatically if files exist)
sudo cp -f ntfs-3g-mount /usr/local/bin
sudo chmod 755 /usr/local/bin/ntfs-3g-mount


sudo cp -f ntfs-3g-mount.plist /Library/LaunchDaemons
sudo chmod 644 /Library/LaunchDaemons/ntfs-3g-mount.plist


# load and start the daemon
sudo launchctl load -w /Library/LaunchDaemons/ntfs-3g-mount.plist


# output status
echo "Current status: (it should have a dash line as it will have finished)"
sudo launchctl list | grep  ntfs-3g-mount


echo "Done!"
exit 0
