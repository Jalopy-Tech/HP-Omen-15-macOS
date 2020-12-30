NTFS-3G for macOS

This software allows macOS to read and write to NTFS volumes.


INSTALLATION

To install  Fuse for macOS with ntfs-3g, do the following:
    1. Install FUSE for macOS (in Apps or http://osxfuse.github.io)
    2. Install Homebrew software downloader package using command:
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    3. Install ntfs-3g package using command:
 brew install ntfs-3g
Volumes can now be mounted using commands like:
diskutil list
sudo mkdir /Volumes/NTFS
sudo /usr/local/bin/ntfs-3g /dev/disk1s1 /Volumes/NTFS -olocal -oallow_other


(source: https://github.com/osxfuse/osxfuse/wiki/NTFS-3G)




AUTOMOUNT AT START UP

There are two approaches:

* Modify the fstab (using sudo vifs)  to prevent volumes based on UUID from being mounted by the native macOS, and run a daemon (using launchctl) which mounts these same UUID volumes using NTFS-3G. Works in Big Sur and Catalina.

OR

*  Replace the native  /sbin/mount_ntfs command with a script which calls the NTFS-3G version. This involves changing a system file. It is easy in Catalina, but currently it is difficult in Big Sur.


MODIFY FSTAB and run DAEMON to automount specific volumes:

1. Edit fstab using sudo vifs to add Volumes which are not to be mounted normally. My full fstab text is in the fstab.txt file in this folder. An example line in in fstab is (UUID can be seen in Disk Util app):

# Prevent Data partition from auto mounting. LABEL= doesn't work.
UUID=BA6C8162-18A7-45D7-99D0-406BA687980E none ntfs ro,noauto



2. Modify ntfs-3g-mount in this folder to include the desired UUID volumes to be mounted as read/write. This file can also be modified in /usr/local/bin after step 3.



3. Run the install.sh script which will copy the ntfs-3g-mount in this folder into /usr/local/bin/ntfs-3g-mount and set up a daemon to run this script automatically.



After every reboot, the volumes should mount as read/write.



REPLACE the native  /sbin/mount_ntfs command in CATALINA:

To allow automatic read/write access by replacing the native macOS NTFS mounter with the ntfs-3g version in Catalina, do the following (specific to Catalina):

1. Reboot macOS to Recovery Mode using Clover.
2. If SIP, isn’t disabled in Clover,  run the command csrutil disable and then reboot into Recovery Mode again.
3. Open Terminal from menu bar -> Utilities -> Terminal
4. Run the command diskutil list
5. In the section “synthesized”, look for the device called “macOS - Data”. Note the identifier (device) e.g. disk2s1
6. Run command (using correct device) diskutil apfs unlockVolume disk2s1
7. Run command cd "/Volumes/macOS/sbin"
8. Backup apple original mount_ntfs use command mv mount_ntfs mount_ntfs.orig
9. Create a new mount_ntfs file with the text:

#!/bin/sh
# fall back to the system version if ntfs-3g is gone.
if [ -x /usr/local/sbin/mount_ntfs ]; then
  exec /usr/local/sbin/mount_ntfs "$@"
else
  exec /sbin/mount_ntfs.orig "$@"
fi
    
10. Link to ntfs-3g using command ln -s /usr/local/sbin/mount_ntfs mount_ntfs
11. Re-enable SIP (if needed) with command csrutil enable
12. Reboot to normal macOS. NTFS volumes should now be mounted as read/write by default using ntfs-3g.

(source: https://github.com/osxfuse/osxfuse/wiki/NTFS-3G#auto-mount-ntfs-volumes-in-read-write-mode-on-macos-1015-catalina)
