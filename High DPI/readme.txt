High DPI script for MacOS

Sets up high DPI to allow large text on high resolutions.

(Source: https://github.com/xzhih/one-key-hidpi#start-of-content)


RUN SCRIPT

The easiest way is to run in terminal:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/xzhih/one-key-hidpi/master/hidpi.sh)"


Or run the local script in the one-key-hidpi-master folder called hidpi.sh like this:
sh hidpi.sh

This script is for Big Sur and should work for Catalina too (the old Catalina version is also there).


MENU OPTIONS IN SCRIPT

Once the script runs, you should have a menu.

In the menu, select menu options:

(1) Enable HIDPI


Then
(3) Macbbook Pro


Then
(1) 1920x1080 Display



Reboot (large apple logo will appear during boot).

To check if it worked, go to Apple menu > About this Mac > System Report and check that Graphics/Displays has resolution 2880 x 1620. Also go to System Preferences > Display and check that resolution is scaled with options for “larger text” “default” “more space”. Leave it on the default. Install RDM next.

RDM (Retina Display Manager)

To change display, install the RDM (retina display manager) macOS app and run (also put in system preferences > Users and Groups > Login Items to run at start up). It will appear as a pulldown menu in top bar. It will show lightning symbols next to ideal resolutions. There should be a lightning symbol for 1440x810 which is a nice resolution for larger size.


CLOVER setting for big apple logo:

To make the Apple logo large right from the start (for consistency), do the following:

1. Mount your EFI Partition (can be done with the ***Clover Configurator*** app)
2. Open your Clover config file: /EFI/Clover/config.plist in **Clover Configurator** and set Boot Graphics > UIScale textbook: **2**
3. Save file and reboot


