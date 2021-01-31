ALC PLUG FIX INSTRUCTIONS


OVERVIEW

The Realtek ALC295 the following issues (which are all be fixed):

1.  Audio input doesn't switch from **Internal Microphone** to **Line In** when plugging in a headset with a mic.
2. The audio has static noise in the left earphone.
3. When rebooting from Windows, the internal speakers don't work.
4. When rebooting from Windows, the internal mic doesn't respond.



TO TEST FIRST:

1.  Run the ALCPlugFix file in the folder alc_fix (use Finder to launch it).
    A terminal will be displayed with messages.
2.  Plug/unplug a headset and see if the terminal responds with messages.

If the ALCPlugFix responds, then the plug/unplug action is being detected. Note that the mic won't change until the scripts are installed  as per the install.sh script below.



TO INSTALL:

1. Make sure CodeCommander.kext is installed in Clover or OpenCore.
2. Replace the hda_verb command in this folder with the latest one from CodeCommander zip donwload to ensure the latest version is being used.
3.  Install using command in Terminal in folder alc_fix:
      sh install.sh



TO UNINSTALL:
1.  Uninstall using command in Terminal in folder alc_fix:
      sh uninstall.sh


TECHNICAL DETAILS:

The original ALCPlugFix program calls two commands:
/usr/local/bin/hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24
/usr/local/bin/hda-verb  0x21 SET_UNSOLICITED_ENABLE 0x83

I modified it to run a script /usr/local/bin/ALCPlugFix.sh instead so as to be able to put in any commands desired into the script. I run two scripts in addition
to the above commands:

 /usr/local/bin/ALCRebootFromWinFix.sh
 /usr/local/bin/ ALCHeadphoneStaticFix.sh
 
 
I did all this because I need to call the ALCHeadphoneStaticFix.sh script to fix the headphone static noise after a wake-from-sleep in addition to initial boot and this program gets called after a wake-from-sleep. Currently there is no native macOS mechanism for running a script upon wake-from-sleep

If you need to change the commands that are run when plugging/unplugging (also runs upon initial startup and wake-from-sleep), then modify the /usr/local/bin/ALCPlugFix.sh script.

If you want to use the original ALCPlugFix program, then you will need to run ALCHeadphoneStaticFix.sh and ALCRebootFromWinFix.sh on start up.
This can be done easily with launch agents, but you also need to run ALCHeadphoneStaticFix.sh after a wake from sleep. Currently there is no native macOS mechanism for this but there are third party products that allow scripts to be run on wake from sleep.


LINUX

Linux has the same problems. I created the same solutions for Linux.

See the Linux folder here (includes readme.txt) for the equivalent fixes and links to forums on the issue.











