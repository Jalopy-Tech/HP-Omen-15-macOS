ALC Plug Fix Selection

To use:

1. Pick an appropriate ALCPlugFix file (see below for choices)
2.  Copy it to the alc_fix fiolder
3.  Remove the existing ALCPlugFix file and rename this one to the same name.
4.  uninstall and reinstall using commands in Terminal:
      sh uninstall.sh
      sh install.sh


ALCPlugFix Choices are:

ALCPlugFix [Pin Control + Left Earphone Static fix]

hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24
hda-verb 0x20 SET_COEF_INDEX 0x67
hda-verb 0x20 SET_PROC_COEF 0x3000



ALCPlugFix [Pin Control]

hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24




ALCPlugFix [Pin Control + Unsolicited Enable]

hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24
hda-verb  0x21 SET_UNSOLICITED_ENABLE 0x83
