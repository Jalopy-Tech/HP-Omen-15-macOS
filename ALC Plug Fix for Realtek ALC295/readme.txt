ALC PLUG FIX INSTRUCTIONS

(See below for Overview and detailed explanation)

This function needs CodecCommander.kext. Get the latest version of this and make sure it runs in Clover or OpenCore.


TO TEST FIRST:

1.  Run the ALCPlugFix file in the folder alc_fix (use Finder to launch it).
    A terminal will be displayed with messages.
2.  Plug/unplug a headset and see if the terminal responds with messages.



TO INSTALL:

1.  Pick an appropriate ALCPlugFix file
2.  Copy it to the alc_fix folder (the one with the ALC295 static fix is already there). Remove the existing ALCPlugFix file in the alc_fix folder and rename this one to the same name within the same folder.

3.  Uninstall if existing installation (see below)
4.  Install using command in Terminal in folder alc_fix:
      sh install.sh



TO UNINSTALL:
1.  Uninstall using command in Terminal in folder alc_fix:
      sh uninstall.sh




ALCPlugFix CHOICES:

File: ALCPlugFix [Pin Control + ALC295 Left Earphone Static fix]
(this file is already in the alc_plug folder – no need to replace it).
This file will fix the plug/unplug mic problem and fix the ALC295 static problem.

Commands:
hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24
hda-verb 0x20 SET_COEF_INDEX 0x67
hda-verb 0x20 SET_PROC_COEF 0x3000




File: ALCPlugFix [Pin Control + Unsolicited Enable]
This file will fix the plug/unplug mic problem

Commands:
hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24
hda-verb  0x21 SET_UNSOLICITED_ENABLE 0x83




File: ALCPlugFix [Pin Control]

Commands:
hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24









OVERVIEW


The Realtek ALC295 has two issues (which can both be fixed):

- Audio input doesn't switch from **Internal Microphone** to **Line In** when plugging in a headset with a mic.
- The audio has static noise in the left earphone

The mic switching problem can be fixed by modifying the **Audio Plug Fix** to work with the Realtek ALC295.


The static noise problem also occurs in Linux and I have posted a fix which can be used in Linux until it is incorporated into the Linux kernel. The same fix can be used in macOS. It involves executing the **hda-verb** command upon startup and wake up. Since the Audio Plug Fix also uses the **hda-verb** command and runs upon start up and wake up, it is very convenient to simply incorporate the static noise fix into the ***Audio Plug Fix\****. I have done so and the compiled fix is available in the zip file. Please note it is best practice to take the original source (which may have updates), do the modifications and recompile. The readme.txt file I have created in the zip provides instructions to do all this.



To install my compilation of the **Audio Plug Fix** which includes the static noise fix, do the following:

1. Make sure CodeCommander.kext is installed in macOS.
2. Test that **hda-verb** is working as follows: in the folder ALCPlugFixforRealtekACL2915/alc_fix , run the program **hda-verb** by double-clicking on it in **Finder**. Give it permissions if needed and make sure it runs in a **Terminal**. It should report "[Process completed]". The window can be closed.
3. Test that **ALCPlugFix** is detecting plugging/unplugging as follows: in the folder ALCPlugFixforRealtekACL2915/alc_fix , run the program **ALCPlugFix** by double-clicking on it in **Finder** It should display a **Terminal**. Every time you plug/unplug a headset, it should respond to a plugging/unplugging event with text output "Audio device changed!" and "Fixing...". The window can be closed.
4. Install as follows: open a **Terminal** in the ALCPlugFixforRealtekACL295/alc_fix folder and run the command sh install.sh (password required). This will install the program to run as a background process which will run at start up.
5. In **System Preferences** > **Sound** > **Input**, check that plugging/unplugging a headset switches between **Internal Microphone** and **Line In**. Adjust the Line In **input volume**. On my machine, with my headsets, it needs to be at around 95%.

  \* The actual **hda-verb** commands that are run are as follows:

hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24

hda-verb 0x20 SET_COEF_INDEX 0x67

hda-verb 0x20 SET_PROC_COEF 0x3000

