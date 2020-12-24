ALC PLUG FIX INSTRUCTIONS


TO TEST:

1.  Run one of the ALCPlugFix files using Finder (choices shown below).
    A terminal will be displayed with messages.
2.  Plug/unplug a headset and see if the terminal responds with messages.



TO INSTALL:

1.  Pick an appropriate ALCPlugFix file (see below for choices)
2.  Copy it to the alc_fix folder
3.  Remove the existing ALCPlugFix file in the alc_fix folder and rename this
    one to the same name within the same folder.
4.  Uninstall if existing installation (see below)
5.  Install using command in Terminal in folder alc_fix:
      sh install.sh



TO UNINSTALL:
1.  Uninstall using command in Terminal in folder alc_fix:
      sh uninstall.sh


ALCPlugFix CHOICES:


File: ALCPlugFix [Pin Control + Left Earphone Static fix]

Commands:
hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24
hda-verb 0x20 SET_COEF_INDEX 0x67
hda-verb 0x20 SET_PROC_COEF 0x3000



File: ALCPlugFix [Pin Control]

Commands:
hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24



File: ALCPlugFix [Pin Control + Unsolicited Enable]

Commands:
hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24
hda-verb  0x21 SET_UNSOLICITED_ENABLE 0x83
