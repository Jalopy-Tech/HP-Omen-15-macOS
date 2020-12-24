# HP-Omen-15-macOS

## Overview

### Specifications

Model : HP Omen 15 Laptop (ax-201)

CPU: i7-7700HQ (Kaby Lake)

Graphics: Intel HD630 (1920x1080), NVIDIA GeForce GTX 1050 (disabled)

Mainboard: HP8259

Drives: Plextor M8Pe(G) 256GB NVMe, Hitachi HGST Travelstar 1TB HDD



### What works

- macOS Catalina (10.15.1, 10.15); Mojave (10.14.6); High Sierra (10.13.6)
- Intel HD Graphics 630
- Plextor M8Pe(G) 256GB NVMe drive*
- USB3 and USB2 ports
- Realtek ALC295 audio including speakers, headphones, internal mic, headset mic.
- Fix for ALC295 issue of static noise in left earphone
- Fix for mic switching when plugging/unplugging a headset
- Volume function keys
- Realtek 8111 PCIe Ethernet
- USB tethering from Android phone for Wifi service
- Synaptics Clickpad (with working Trackpad gestures)
- Realtek RTS522A PCIe Card Reader (a little buggy but works okay)
- Bluetooth
- HP Wide Vision webcam
- Start/Shutdown/Restart
- Sleep/Wake (including close/open on lid)
- Battery Meter
- Sensors for CPU, drives and battery including temperature monitoring.
- Brightness function keys
- High DPI settings for large text display
- Catalina/Mojave upgrades (all work fine so far)
- Booting from grub2 by chain loading Clover
- Read/write access to NTFS (Windows) partitions using NTFS-3G (free) or a commercial product.
- Linux read access to APFS partitions using apfs-fuse

\* The Plextor NVMe drive is accessible with Clover and is supported by Catalina and Mojave. High Sierra doesn’t have native support. There is a High Sierra patch for Plextor drives: I don’t know if it works with this model as I haven't tried it.



### What doesn't work

- Nvidia GeForce GTX 1050 “switchable” graphics (currently not supported*)
- HDMI port (currently not supported*)
- Intel Wi-Fi (currently not supported**)

\* This machine uses a “switchable” dual GPU (Intel iGPU/Nvidia dGPU) which is supported in Windows and Linux. Unfortunately there is no support in macOS. Even with working NVidia Web drivers which are currently available for High Sierra 10.13.6 (not Mojave or Catalina), the NVidia dGPU still can’t be used due to the switching set up which is not supported. The HTML port is routed through the NVidia GPU (stated in the HP Omen 15 Maintenance manual and confirmed in Windows) which means this is also not supported. Following this guide will result in the dGPU being switched off in macOS, thus saving power and allowing sleep/wake. This won’t affect operation in Windows or Linux.

** Intel Wi-Fi devices are not currently supported in macOS. For quick and easy Wi-Fi access, you can use USB phone tethering (see below) or a compatible USB Wi-Fi device. For a more permanent solution, you can replace the Intel Wi-Fi device with a compatible Wi-Fi device (not expensive). For ethernet network, the Realtek ethernet device works fine.



### What's not yet tested

- Apple software such as iMessage, iCloud, etc (I’m not an Apple user).



### Outstanding Issues

- Machine wakes from sleep when plugging/unplugging a USB device (including when lid is closed)
- Machine takes on about 20 to 30 seconds to sleep (apparently this is expected for a "Hackintosh")



## Introduction

Hi Folks, This is my first "Hackintosh" and my first time using macOS. I am a Linux user, but decided to install macOS on my laptop with the maximum capability possible out of curiosity and this is the result. As a beginner, I have gone into some detail in the hopes that this might help other beginners. Apologies to those experienced in all this, as this guide may seem overly verbose. All tips, suggestions, constructive criticism and other feedback are most welcome. Cheers.



## Pre-installation

### Image Backups (for beginners)

If you don't know how to backup and restore images of your partitions, I strongly suggest you learn how to do this before playing around with macOS (or Linux or Windows for that matter) as this will save you a lot of hassle and worry. I have backups of all important partitions on external devices (including Linux, Windows and all my data). There is plenty of image backup software available online.



During this process, I made a new image of my EFI (boot partition) and APFS (macOS partition) upon every milestone I achieved. I restored to the last "clean" milestone after any experimenting and kept multiple copies of the Clover folder when trying out various Clover configurations. At the very least you should:

- Backup and restore all important partitions to external media.
- Be able to boot from an external device (e.g. USB) to recover your system.
- Be able restore your entire system from external media if necessary.
- Maintain backups of your Clover folder and your APFS partition(s) for every milestone achieved.
- Restore to the last milestone when needed or if your current installation is too "messed up".
- Make sure you have a backup before trying a macOS upgrade.
- Be able to create, delete, move and resize partitions when needed.



### Preparation (for beginners)

The macOS installation media consists of two parts. Firstly, a Clover installation which usually consists of ***Clover\*** (boot manager software) being installed on an EFI partition such as one on a USB stick. Secondly, a separate HFS+ (macOS extended) partition which contains the native macOS installation files for the version of macOS required - this can also be put on the same USB stick.



The easiest way to set up installation media is to use a USB 2.0 stick (USB 3.0 may not be initially recognized in macOS on your target machine). You need to access a machine with a working macOS* and do the following:

1. Make sure the USB is formatted with a GPT partition table (not MBR).
2. Install ***Clover*** to the USB stick (use default UEFI settings).
3. Use ***Clover Configurator\*** to adjust any config.plist settings in the USB stick's EFI Clover in order to allow your machine to run a macOS installation (see below for my initial Clover Configuration).
4. Download all needed kexts and drivers and copy to the USB stick's EFI Clover folders (see below).
5. Add a partition to the USB stick with the desired macOS installation.

As I didn't initially have access to macOS, I actually downloaded and installed a non-vanilla "Hackintosh" installation image which ran successfully. It was not a good set up, but at least I could use it to create a proper USB stick for installation. After that I ditched it. If you have access to a running macOS installation*, I recommend using this instead as it will be a lot less hassle and less prone to problems.



On the target machine, I recommend creating a labelled NTFS partition for macOS which can be reformatted into an APFS partition at the start of the macOS installation. I recommend 40+ GB as a minimum.

You need to be able to boot the target machine from the USB stick to run the macOS installation. The installation will reboot the machine multiple times so you can either set you machine's BIOS to boot from the stick by default or manually choose the USB stick on each reboot.

On the target machine I already had secure boot disabled in the BIOS. I didn't need to change any other BIOS settings.

There are plenty of online resources that cover setting up a USB installation in much more detail.

\* Any macOS installation can be used including a "Hackintosh" or virtual machine running macOS. I've even heard of machines called "Macs" that actually run macOS as well (I'm not sure if people actually use these or if it's just a myth).



### Initial Clover Configuration for macOS Installation

The default Clover configuration for UEFI installation doesn't work without two extra settings that needs to be added with ***Clover Configurator\*** otherwise the macOS installer hangs. Make sure your USB EFI partition is mounted and open your Clover config file: /EFI/Clover/config.plist in ***Clover Configurator***. Add the following settings:

ACPI > Patches (for DSDT): add the patch **change EC0 to EC** (click on the **List of Patches** button and choose it)

Devices > USB > enable **Inject**

The following settings also made Clover easier to use:

Boot > Arguments > add the boot argument **-v** from the right-click menu (verbose mode to view output for troubleshooting).

GUI > Screen Resolution: **1920x1080** (or your desired screen resolution in Clover)

GUI > Mouse > Speed: **8** (in Clover***,\*** the USB mouse has a very slow pointer speed without this setting)

I don't use the Clover graphics settings for my video and CPU as WhateverGreen auto detects this (later I will use video patching anyway - see below). If you have trouble booting into the macOS installer, you can add these two Clover settings to see if it fixes the problem. You need to look up the correct values for your CPU and video device before adding them using ***Clover Configurator\***. My values are:

Devices > intelGFX textbox: **0x59168086** (for Kaby Lake with Intel HD) - I don't need this as it is auto detected.

Graphics > ig-platform-id textbox: **0x591b0000** (for Kaby Lake laptops with Intel HD 610 - 650) - I don't need this as it is auto detected.

See below for my complete Clover Configuration settings which are not needed now (but can be used) for initial installation. If you have issues, you may wish to use my complete clover settings now rather than later (see below).



### Clover Kexts

The following Kext Files (latest versions recommended) need to be downloaded and copied to Clover in the USB EFI Clover folder /EFI/Clover/Kexts/Other

- FakeSMC.kext OR VirtualSMC.kext (to fake a Mac)
- Lilu.kext (patcher)
- RealtekRTL8111.kext (ethernet network)
- USBInjectAll.kext (USB)
- VoodooPS2Controller.kext (mouse and touchpad)
- WhateverGreen.kext (video)



The file SSDT-PNLF.aml from the WhateverGreen.kext repository/download should be copied into the USB EFI Clover folder /EFI/Clover/ACPI/patched .



All the Clover drivers should already be present, but check that they are in the USB EFI Clover folder /EFI/Clover/drivers/UEFI:

- APFSDriverLoader.efi (to read Apple’s APFS partitions)
- AptioMemorytFix.efi
- HFSPlus.efi (to read Apple’s HFS+ partitions)
- SMCHelper.efi (using FakeSMC.kext) OR VirtualSmc.efi (using VirtualSMC.kext)



### Network Access (for beginners)

macOS installation doesn't need Internet access during installation. To have network access on the target machine, you can do one of the following:

- Use ethernet. The RealtekRTL8111.kext (see above) will allow ethernet network during and after macOS installation.
- Use USB Wi-Fi tethering. The ***HoRNDIS\*** app allows USB tethering from an Android phone for WiFi access, so you can download this app and have it ready to install on the target machine after installation. https://joshuawise.com/horndis#available_versions . If you need Internet access during macOS installation, you can even copy the HoRNDIS.kext file to the Clover folder /EFI/Clover/Kexts/Other and turn on USB tethering on the Android phone before starting the installation. In Catalina, the install script doesn't work, but has been modified to run. I have included it in my zip file.
- Use a USB Wi-Fi Stick. You will need to check if it's compatible and if you need any special application/kext(s).



## Installation

### Installation of macOS (for beginners)

To install macOS, boot up ***Clover\*** from the USB stick and select the macOS installer partition in the Clover menu. Be aware the installation may appear to hang during parts of the installation but give each such occurrence at least 5 minutes before concluding it has hung. If you arrive at the initial GUI installation wizard/menu, then this usually indicates that your Clover set up is good enough for a successful installation. This is the place to run ***Disk Utility\*** and reformat your prepared NTFS partition into APFS format. If you get errors here, you may have a bad macOS installer. Try a different version, or try creating an EFI partition on your partition's device if one is not present. Once you have successfully reformatted to APFS, close Disk Utility and you should be able to select your new partition as the target for installation within the install wizard. The installation will continue on with a number of reboots. The machine needs to boot from your USB stick upon each reboot.

On each reboot (using the USB stick), Clover should run and pick the correct partition to continue the installation, but if you end up back at the initial GUI installation wizard, then reboot into Clover and manually select your new APFS partition from the Clover menu. Alongside (actually just before) your new partition, the Clover menu should also display two extra partitions: **Filevault Preboot for macOS** and **Recovery**. The preboot partition can be used instead of booting directly into your partition as desired. Later, if you encrypt your partition using ***FileVault\***, you must use this preboot partition to enter your password.



### Setting Up Clover as the Primary Boot Manager (for beginners)

Now that you have a working macOS installation (booted from the USB stick), you can install ***Clover\*** into your internal drive that you wish to boot from.

If your machine boots directly into Windows, you are probably using the Window's boot manager. Microsoft doesn't allow non-Microsoft systems to be booted from it, so you will need to use Clover or a third party boot manager such as ***grub2\*** to boot both macOS and any other system(s) such a Windows or Linux.

If your internal drive doesn't use a GPT partition table, it needs to be converted to GPT. If the EFI partition is less than 200 MB, you need to resize/move your adjacent partition(s) to make room and increase the EFI partition to 200 MB or more (I use 1 GB for my EFI partition). If you don't know what software to use, you can download ***GParted\*** and create a USB boot drive to run it. This will do partition resizing, moving, etc (make sure you have image backups of your partitions first). If you need to create a new EFI partition on a drive, you can create a FAT32 partition with the bootflags **boot** and **esp** enabled. You can label it "EFI" for easy identification.

If you wish to use **Clover** as your primary boot manager on your internal drive, do the following:

1. Make sure your internal drive uses a GPT partition table.
2. Make sure your internal drive has an EFI partition of 200 MB or more (see above).
3. Test that you can boot into your other operating system(s) (e.g. Windows) using Clover's menu (from your USB stick).
4. Boot into macOS using your USB stick.
5. Run the ***Clover\*** installer app and choose your internal drive to install to (i.e. choose a partition on this drive) and then install Clover.
6. Mount both your internal drive's EFI partition and your USB EFI partition (you can use ***Clover Configurator\*** to mount these EFI partitions).
7. Use ***Finder\*** to delete the /EFI/Clover folder from your internal drive's EFI and replace it by copying the /EFI/Clover folder from the USB stick to this place. This means all the Clover settings from the USB stick will be copied over.
8. Check that you can boot into Clover on the internal drive (i.e. without the USB stick). You may need to set this up in your BIOS settings.



### Setting up grub2 to Chainload Clover

Since I use Linux and Windows, I use ***grub2\*** as my primary boot manager. If this is the case you don't need to install ***Clover\*** on the drive. Just do the following:

1. Check that your internal drive's EFI partition is 200 MB or more. If not, resize it (see previous section).
2. Mount both your internal drive's EFI partition and your USB EFI partition (use Linux, macOS, Windows, whatever).
3. Copy the /EFI/Clover folder from the USB's EFI partition to your internal drive's EFI partition.
4. Add a ***grub2\*** menu entry with the following script:

echo "Starting macOS..."

savedefault

search --fs-uuid --no-floppy --set=root [UUID]

chainloader /EFI/clover/CLOVERX64.efi



Replace the [UUID] with the actual UUID number for the macOS partition.



## Post-installation

### **Network Access**

See section above concerning network access.



### Complete Clover Setup

I use a minimalist strategy for setting up my Clover configuration: I turn off all options unless they are necessary. The following are the options used for each Clover Configurator settings section (all other options are turned off/disabled) with screen shots included. Make sure your EFI partition is mounted and open your Clover config file: /EFI/Clover/config.plist in ***Clover Configurator\***. Have only the following settings enabled (screenshots included):



#### ACPI



ACPI > Patches (for DSDT) list: add the patch **change EC0 to EC** (click **List of Patches** button to add) (required to stop macOS startup hang)

ACPI > SSDT > Plugin Type checkbox: **checked**

ACPI > AutoMerge and Fix Headers checkboxes: enabled (for SSDT patching)



#### Boot

Boot > Default Boot Volume combolist: **Last Booted Volume** (default setting)



#### Boot Graphics

Boot Graphics > UIScale textbook: **2** (keeps startup Apple logo large on startup which looks consistent when using HiDPI text)



#### CPU

[nothing set]



#### Devices

Devices > USB > Inject checkbox: **checked** (required to stop macOS startup hang)

Devices > Audio > Inject combolist: **No** (not needed as audio patching will be used - see below).

Devices > Properties button > Devices (with properties): I have two devices set up (audio and video), but you should leave this all blank as it will be filled in later by Hackintool when setting up video and audio patching (see below).



#### Disable Drivers

[nothing set]



#### Gui

Gui > Scan > Custom button: **selected** (I want to control the menu options in Clover)

Gui > Scan > Entries checkbox: **checked** (to see the macOS/Windows partitions)

Gui > Hide Volume List: **Win10Pro, bootmgfw.efi** (I don't Clover to show my Windows partitions as I use grub2, you can also add **Preboot** and/or **Recovery** if you want to hide these menu options).



#### Graphics

[nothing set]



#### Kernel and Kext Patches

Kernel and Kext Patches > Kernel LAPIC checkbox: **checked** (recommended for HP laptops)



#### RT Variables

RT Variables > BooterConfig textbox: **0x28** (default)

RT Variables > CSRActiveConfig: **0x67** (disables SIP - this can be set to **0x00** to enable SIP when all set up is finished, but most users leave it disabled as it may interfere with upgrades and kext updates.



#### SMBIOS

I set this to **MacBookPro 14,3** (mobile should be **checked)** as this closely resembles the specs of this machine - particularly the CPU.



#### System Parameters

System Parameters > Inject Texts Combolist: **Detect** (default setting)





#### Save and Reboot

Save the file and reboot for settings to take effect.





### Installing Kexts (for beginners)

If a kext is "as is" and doesn't come with an installer, I recommend using the ***Hackintool\*** app to install it (***Kext Wizard\*** and ***Kext Installer\*** apps are outdated).

To install one or more kexts, do the following:

1. Mount the partition that the kexts are located in (mount the EFI partition if installing from /EFI/Clover/kexts/other folder).
2. Open the ***Hackintool\*** app.
3. At the top in the toolbar, click the tool-button called **Tools** .
4. At the bottom, click the house icon called **Disable gatekeeper...**
5. At the bottom, click the left lego-block icon called Install Kext(s)
6. Select the kexts to install - multiple kexts may be selected in the folder.

Hackintool will copy the kexts to /L/E, automatically rebuild the cache, repair permissions and display a log. There will be a list of kexts with an "invalid signature" - this is expected.



I follow the recommendation of installing all texts from Clover (/EFI/Clover/kexts/other folder) into macOS. This includes:

- FakeSMC.kext OR VirtualSMC.kext
- Lilu.kext
- RealtekRTL8111.kext
- USBInjectAll.kext
- VoodooPS2Controller.kext
- WhateverGreen.kext

I don't put any other kexts into Clover unless needed for booting macOS. In fact, after installation you can remove all kexts from Clover if you want (I just leave them there).



I install all other kexts into macOS (not ***Clover\***) using ***Hackintool\***. This includes:

- ACPIBatterManager.kext (battery and to allow touchpad gestures)
- Sinetek-rtsx.kext (card reader)
- AppleALC.kext (audio)
- CodeCommander.kext (needed for audio plug fix)



### Uninstalling Kexts (for beginners)

If a kext is "as is" and doesn't come with an uninstaller, I recommend ***Finder\*** and ***Hackintool\*** to uninstall it:

1. Open ***Finder\*** app.
2. If you don't have your machine displayed in the sidebar under locations, you can show this with Finder's Preferences menu option.
3. Go to the folder in [your machine]/[your macOS partition]/Library/Extensions
4. Delete the desired kext(s).
5. Open ***Hackintool\*** app.
6. At the top in the toolbar, click the tool-button called **Tools** .
7. At the bottom, click the house icon called **Disable gatekeeper...**
8. At the bottom, click the right lego-block icon called **Rebuilt KextCache and Repair Permissions**



### Sensor Kexts

To enable sensors, install the FakeSMC sensor kexts OR Virtual SMC sensor kexts into macOS as follows:



Fake SMC kexts:

- FakeSMC.kext
- FakeSMC_ACPISensors.kext
- FakeSMC_CPUSensors.kext
- FakeSMC_GPUSensors.kext
- FakeSMC_LPCSensors.kext
- FakeSMC_SMMSensors.kext



Virutal SMC kexts*:

- SMCLightSensor.kext
- SMCProcessor.kext
- SMCSuperIO.kext
- VirtualSMC.kext

\* Note that for VirtualSMC, the SMCBatteryManager.kext is not listed. On my machine, this kext slows down macOS startup and doesn’t add any new sensor functionailty.



If switching from FakeSMC to VirtualSMC or visa-versa, do the following:

1. Replace the main SMC kext in the Clover folder /EFI/Clover/kexts/Other (see Clover Setup)
2. Replace the SMC .efi driver in the Clover folder /EFI/Clover/drivers/UEFI
3. Uninstall the main SMC kext and sensor kexts in macOS.
4. Install the new main SMC kext and sensor kexts in macOS.



Install the ***HWMonitor\*** app to view and monitor sensors. In the app's preferences you can set it to be started at login.



### HiDPI Text (for beginners)

To allow HiDPI text, do the following:

1. Download xzhih's [***one-key-hidpi\***](https://github.com/xzhih/one-key-hidpi).
2. Open a ***Terminal\*** in the Downloads/one-key-hidpi-master folder and run: [ICODE]sh hidpi.sh[/ICODE]
3. In the Terminal window, select **(1) Enable HIDPI**, then select **(5) Remain as is**, then select (3) **Manual Input resolution**, then enter **1920x1080**.
4. Reboot as instructed.
5. In System Preferences > Display, set the Resolution to **Scaled**
6. Install the app ***RDM\* http://avi.alkalay.net/software/RDM/** (Retina Display Manager) and run it.
7. The RDM app icon will appear at the top. Select a resolution as desired. The resolutions marked with a flash symbol indicate resolutions which will have clear text due to being harmonious with the actual display resolution.
8. Th RDM app can be set to run at login using ***System Preferences\*** > Users & Groups > Login Items



To make the Apple logo large right from the start (for consistency), do the following:

1. Mount your EFI Partition (can be done with the ***Clover Configurator*** app)
2. Open your Clover config file: /EFI/Clover/config.plist in ***Clover Configurator\*** and set Boot Graphics > UIScale textbook: **2**
3. Save file and reboot





## Patching

### Video and Audio Patching (for beginners)

#### Introduction

Before patching, you need to know/look up your CPU Intel generation (Skylake, Kaby Lake, Coffee Lake, etc) and GPU Platform ID (aka ig-platform-id). For my machine's specs, it is **Kaby Lake** and **0x591b0000** respectively. You also need to know/look up the audio card's Layout ID. For the Realtek ALC295 audio device, any of the standard values **1**, **3** or **13** work on my machine.

You should also run the ***Hackintool\*** app and make sure the following menu items are checked (these checks should stick when rerunning this app):

- Framebuffer > **macOS 10.14** (I have had no problems in Catalina 10.15.1 with this setting)
- Patch > **Apply current patches**

I suggest patching video first, then audio.



#### Video Patching

To patch video, do the following:

1. Make sure the WhateverGreen.kext is installed in macOS (see above for installing kexts with ***Hackintool\***).
2. Make sure the file SSDT-PNLF.aml from the ***WhateverGreen Kext\*** repository/download has been copied into the Clover folder /EFI/Clover/ACPI/patched .
3. Mount your EFI Partition (can be done with the ***Clover Configurator*** app)
4. Open the ***Hackintool*** app and click the tool button **Patch**.
5. Set the Intel generation and Platform ID to the correct values.
6. Click the **Patch** button at the bottom.
7. Under Patch options, click on the **Advanced button.**
8. Set Disable eGPU and Spoof Device ID to **checked**.
9. Make sure the combo box to the right of Spoof Device ID is set to your correct graphics card. For my machine it is **0x591B: Intel Graphics HD 630** .
10. Click the **Generate Patch** button.
11. Select the menu File > Export > Bootloader config.plist .
12. Make sure the file location is your EFI partition, in the folder /EFI/Clover and click **Save**
13. Reboot



To check that the integrated GPU is recognised and the dedicated GPU has been disabled, do the following:

1. Go to Apple menu > About this Mac > **System Report** button.
2. Select **Graphic/Displays** (left side)
3. Make sure that only the Intel graphics card is shown (and not your dedicated graphics such as Nvidia or AMD).



#### Audio Patching

To patch the audio, do the following:

1. Make sure AppleALC.kext is installed in macOS (see above for installing kexts with ***Hackintool\***).
2. Mount your EFI Partition (can be done with ***Clover Configurator\***)
3. Open the ***Hackintool\*** app and click the tool button **Audio**.
4. Select your audio device which should be shown in Audio Devices.
5. Set the Layout ID for your audio device. For my Realtek ALC295: **1**, **3** and **13** all work.
6. Click the tool button **Patch**.
7. Make sure the Intel generation and Platform ID are still set to the correct values.
8. Click the **Patch** button at the bottom.
9. Click the **Generate Patch** button.
10. Select the menu: File > Export > Bootloader config.plist .
11. Make sure the file location is your EFI partition, and folder /EFI/Clover and click **Save**
12. Reboot



To check that the audio device is recognised, do the following:

1. Go to Apple menu > About this Mac > **System Report** button.
2. Select left side **Audio** and make sure that an audio device is present.



If ***Hackintool\***, doesn't show your device, first make sure your dGPU is turned off (see Video patching above). Also try opening your Clover config.plist using ***Clover Configurator\*** and adding the layout ID in:

Devices > Audio > Inject. Save and reboot. Then try to patch again using ***Hackintool\***. If successful, you should reset the Devices > Audio > Inject value back to blank.



Sometimes the audio layout-id selection doesn't stick in ***Hackintool\***. If so, try Hackintool again. If it still doesn't stick, try adding the layout id using ***Clover Configurator\*** as described just above.



If the audio layout ID is still resetting in ***Hackintool\***, you can manually adjust the layout ID as follows:

1. Open your Clover config.plist using ***Clover Configurator.\***
2. Go to Devices and click on the **Properties** button.
3. In the Devices list on the left, select the audio device which should be something like **PciRoot(0x0)/Pci(0x1f,0x3)** .
4. In the Properties key list on the right, find the layout-id and change the value by changing the first two digits to the layout-id value in hexadecimal. e.g. layout-id of 1: **01000000**, layout-id of 13: **0D000000**, etc.
5. Save and Reboot.

Once your audio is shown in the system report, you should get sound. Your volume keys should also work.



### DSDT Patching (for Battery Meter and Brightness Keys)



I needed to patch my DSDT to add the following features:

- Fix battery status
- Allow trackpad gestures (needs battery status working).
- Allow brightness keys.

I applied two patches:

1. DSDT-Battery-Patch.txt*
2. DSDT-Brightness-Keys-Patch.txt

These patches are in my configuration available for download.



To patch your DSDT, do the following:

1. If patching for your battery, make sure ACPIBatterManager.kext is installed in macOS.
2. Install the ***MACiASL*** app if not installed.
3. Reboot and in the ***Clover\*** menu, press **F4**. Clover doesn't give any feedback.
4. Mount your EFI Partition and check that the folder /EFI/Clover/ACPI/origin is full of .aml files which should be new. If you want to verify that this is working, you can check the file dates, or delete all the files in this folder and do the previous step again.
5. Copy the file /EFI/Clover/ACPI/origin/DSDT.asl to the folder /EFI/Clover/ACPI/patched . If there is already a DSDT.asl file present, you can replace it as you shouldn't need it, but you may wish to copy it first for safe keeping (just in case).
6. Open the /EFI/Clover/ACPI/patched/DSDT.asl file in ***MACiASL\*** (this app should be the default for .asl files)**.
7. Click the tool button **Compile** to make sure there are no errors (warnings are fine). The compile summary window can then be closed.
8. For each patch do the following:
   1. Click the tool button **Patch** to bring down the patching window.
   2. Open the patch .txt file in a seperate app.
   3. Copy/Paste the text from the patch .txt file to the patch text window in the ***MACiASL\*** app
   4. Click the **Apply** button.
   5. Click the **Close** button.
   6. Click the tool button **Compile** to make sure there are no errors (warnings are fine). The compile summary window can then be closed.
9. After all patches have been applied and there are no compile errors, use the menu File > Save to save the DSDT.asl file.
10. Reboot for changes to take effect.

You can check that your battery meter is working by displaying it using ***System Preferences\*** > Energy Saver > Show battery status in menu bar : **checked**. The battery meter symbol should appear and stay (if it disappears almost instantly, it isn't patched correctly). Once the battery meter is working, you should be able to see/adjust trackpad gestures using ***System Preferences\*** > Trackpad.



You can test your brightness keys F2 and F3. If they don't work, check that you can adjust the brightness control in ***System Preferences\*** > Displays > Brightness dial. If the brightness control is missing, check your video patching and make sure the dGPU is switched off. If the brightness control works, but the brightness keys don't work, check the brightness patch.



If you need to redo any patching or want to remove any patches, you should do all the steps above again (i.e. copy the the original DSDT.asl file again and patch with ***MACiASL\***).



If you want to add a patch (leaving the existing patches as is), you can just add the patch to the existing /EFI/Clover/ACPI/patched/DSDT.asl file, compile and save.



If your BIOS changes due to hardware changes or BIOS firmware updates, you need to redo all these steps (i.e. use F4 and repatch from the original DSDT.asl file). There is a more dynamic "hot patching" method available for DSDT patching, but it is recommended not to try this out until you know the basics as described here.



\* The DSDT-Battery-Patch.txt contains the same patch as the one in the patch repositories within ***MACiASL\*** under **_RehabMan Laptop/[bat] HP Paviliion n012tx** .



** I know the recommended procedure is not to open .asl files with ***MACiASL\*** directly , but rather to compile them into .dsl files first using ***iasl\*** and then open the .dsl files, patch and then compile back to .asl. I tried this and kept getting endless errors (I used refs.txt and error-line commenting). When I do it as described above, I get no errors and everything works perfectly. Right now I am unrepentant. If I change my mind, I will confess the error of my ways and amend this guide while wearing sackcloth and ashes. 



### USB Port Fix using SSDT Patching (for beginners)

#### Introduction

macOS handles ports through a pool of port names such HS01, HS02, HS03, SS01, SS02, USR1, etc. Each of your machine's USB ports will be assigned to one or more of these port names. The problem is macOS has a limit to how many such port names from the pool can be used at any one time. This is known as the "USB Port Limit". This means that if you haven't manually included or excluded any port names from the pool, then some port names will be left out. For example, your USB 3 port names (SS port names) are probably left out right now, which means USB 3 devices won't work. To fix this problem, you can work out which port names are needed and which are not, and then manually exclude port names not needed, allowing "left out" port names to be let back in. Once enough port names have been excluded, all other port names from the pool will be "let in" and seen. SSDT can then be patched for the exact port names needed. If this is confusing, don't worry. Just work through the stages below.



#### Stage 1 - Exclude unneeded USB 2 ports (HS port names)

1. Check that USBInjectAll.kext is installed in /EFI/Clover/kexts/other and in macOS.
2. Get a USB 2.0 device to use for testing (such as a USB 2.0 mouse or USB 2.0 stick). A USB 3 hub will also work as it registers as both a USB 2.0 and USB 3.0 device, but don't use an ordinary USB 3.0 device such as a USB 3.0 drive.
3. Mount your EFI Partition and check that there is no file SSDT-UIAC.aml in the Clover folder /EFI/Clover/ACPI/patched . If the file exists, you can delete it, but you may wish to copy it first for safe keeping (just in case).
4. Run the ***Hackintool\*** app
5. Click on the tool button **USB**
6. Click on the buttons (at bottom) **Clear All** and then **Refresh**.
7. You should see a list of port names (mainly HS port names from HS01 to HS14 and possibly some others). These HS port names are for USB 2 devices including internal devices such as an internal hub, webcam and bluetooth. The ones highlighted in green are currently being used.
8. Use your USB 2.0 testing device to plug and unplug into every possible USB port. When a port name is used, it will be highlighted in green. Don't forget to also test USB 3.0 ports with your USB 2.0 device. I recommend testing ports that are currently being used such as for a USB mouse or keyboard. These ports should have port names that are already highlighted, but it's good to double check.
9. After testing thoroughly, some HS port names will not be highlighted in green. These port names are NOT needed: note these port names.
10. Make sure your EFI partition is mounted and open your Clover config file: /EFI/Clover/config.plist in ***Clover Configurator.\***
11. In Boot > Arguments, add the following boot argument: **uia_exclude=** but also add the port names for those that are NOT needed (separated by commas). e.g. **uia_exclude=HS05,HS06,HS08,HS09,HS10,HS11,HS12,HS13,HS14** (this will exclude all HS port names except HS01 to HS04 and HS07). Note that if your machine needs many HS port names, feel free to temporarily exclude the ones that you are not using right now (eg. port names for empty USB ports, webcam, etc) in order to allow maximum room for currently "left out" port names to be seen. But before you patch, you need to remove these port names from the exclude list to allow them back in for patching.
12. Save the file and reboot.
13. Run the ***Hackintool\*** app
14. Click on the tool button **USB**
15. Click on the buttons (at bottom) **Clear All** and then **Refresh**.
16. Check that the list still contains the same HS port names that you didn't exclude, but doesn't include the HS port names that you did exclude. If there are now additional HS port names that weren't present before, repeat this stage (testing with a USB 2.0 device), checking to see if they become highlighted in green, thus indicating that they being used. Exclude the new HS port names that are not needed by adding them to the **uia_exclude=**... list as described above and then reboot. You should reach the place where you know all the HS port names that you need and all the ones you don't need. You should also notice that a whole bunch of SS ports are now present.



#### Stage 2 - Exclude unneeded USB 3 ports (SS port names)

1. Get a USB 3.0 device to use for testing (such as a USB 3.0 drive). A USB 3 hub will also work as it registers as both a USB 2.0 and USB 3.0 device, but don't use a USB 2.0 device.
2. Run the ***Hackintool\*** app
3. Click on the tool button **USB**
4. Click on the buttons (at bottom) **Clear All** and then **Refresh**.
5. You should see the list of HS port names that you didn't exclude. You should also see SS port names and possibly some others. These SS port names are for USB 3 devices. Note the SS port names that are highlighted in green are currently being used.
6. Use your USB 3.0 testing device to plug and unplug into every possible USB port. When a port name is used, it will be highlighted in green. If a HS port name (and not SS port name) becomes highlighted, it indicates that this port is USB 2 only. Don't forget to also test all ports that you are currently using such as the ones for your USB mouse and USB keyboard as these ports also need to be tested for USB 3.
7. After testing thoroughly, some SS ports will not be highlighted in green. These ports are NOT needed: note these ports.
8. Make sure your EFI partition is mounted and open your Clover config file: /EFI/Clover/config.plist in ***Clover Configurator\***.
9. In Boot > Arguments, edit the existing **uia_exclude=...** boot argument and add on the SS port names that are NOT needed (separated by commas).
10. Save the file and reboot.
11. Run the ***Hackintool\*** app
12. Click on the tool button **USB**
13. Click on the buttons (at bottom) **Clear All** and then **Refresh**.
14. Check that the list still contains the same HS and SS port names that were previously highlighted in green before, but doesn't include the HS and SS port names that were excluded in Clover Configurator. If there are now additional SS port names that weren't present before, repeat this stage (testing with a USB 3.0 device), making sure that these new SS port names are not needed. Exclude the new SS port names that are not needed by adding them to the **uia_exclude=**... list as described above. If you need a lot of port names, feel free to also exclude SS port names that need but aren't using now, but remember to remove them from the exclude list before patching. You should reach the place where you know all the SS port names that you need and all the ones you don't need (just like with the HS port names from the last stage).



#### Stage 3 - Exclude unneeded other ports

You may find that you have some other port names such as USR1 and USR2. As long as these port names didn't ever get highlighted in green, they can also be excluded in ***Clover Configurator\*** as detailed above.



#### Stage 4 - Create Patch

To create the patch, do the following:

1. If you excluded needed port names temporarily in previous steps, remove them from the **uia_exclude=**... list to allow them to be seen again. Make sure all port names that are NOT needed, are in the exclude list. Save and reboot.
2. Run the ***Hackintool\*** app
3. Click on the tool button **USB**
4. Click on the buttons (at bottom) **Clear All** and then **Refresh**.
5. You should check that all the port names listed are the ones that are needed and there are no ones that are not needed.
6. For each port name, choose the connector from the combolist. Use the following rules:
   - If the port name is linked to a USB-C port, click the **Info** button (at the bottom) to read and check whether to choose **TypeC** or **TypeC+Sw**
   - If the port name is for an internal device such as an internal hub or webcam and not for a physical USB port, choose **Internal**.
   - If the port name is an SS and linked to a physical USB 3 port, choose **USB 3**.
   - If the port name is an HS and linked to a physical USB 3 port (i.e. the physical port also has an asscociated SS port name), choose **USB 3** (don't choose USB2 even though it is an HH port name).
   - If the port name is an HS and linked to a physical USB 2 port (i.e. the physical port doesn't have an SS port name because it isn't a USB 3 port), choose **USB 2**.
7. Click the **Export** button (at the bottom). Some new files should be created on the desktop: SSDT-UIAC.aml, SSDT-EC.aml and USBPorts.kext.
8. If you wish to double check the patch, you can open the desktop SSDT-UIAC.aml file in the ***MACiASL\*** app to check that all the port names are present.



#### Stage 5 - Apply the patch

To apply the patch:

1. Mount the EFI partition and copy the desktop SSDT-UIAC.aml* and SSDT-EC.aml files to the Clover folder /EFI/Clover/ACPI/patched .
2. Open your Clover config file: /EFI/Clover/config.plist in ***Clover Configurator\*** and in Boot > Arguments, remove the **uia_exclude=...** boot argument.
3. Save the file and reboot.
4. Run the ***Hackintool\*** app
5. Click on the tool button **USB**
6. Click on the buttons (at bottom) **Clear All** and then **Refresh**.
7. Check that the list contains all port names needed and no others. The connectors should be set as per the previous stage.

\* Instead of using SSDT-UIAC.aml, you can replace USBInjectAll.kext with the desktop USBPorts.kext (do this in both ***Clover\*** and macOS).



### Sleeping and Waking Up (for beginners)

To allow sleeping and waking up, do the following:

1. Patch the video as described above. Make sure the dGPU has been disabled as described in that section.
2. Patch the DSDT as described above.
3. Patch the USB ports as described above.
4. In ***System Preferences\*** > Energy Saver, make sure "Wake for Ethernet network access" and "Enable Power Nap while plugged into a power adapter" are **unchecked**.
5. Run the ***Hackintool\*** app
6. Click on the tool button **Power**
7. Click on the buttons (at bottom) **Fix Sleeping Image** (password needed) and then **Refresh**. Once done, you should see some green highlighted rows, but no red highlighted rows.
8. Reboot and test sleeping/wake up including close/open on lid (see notes below).



My machine takes 20 seconds to sleep on the first sleep and 20 to 40 seconds on subsequent sleeps: this is normal for a "Hackintosh". It sleeps on lid close and wakes on lid open. The machine doesn't wake on USB mouse movement, only clicking.



Unfortunately, the machine wakes if there is any plugging/unplugging of a USB device including on lid closed. I have tried to disable this by patching the DSDT, but haven't found a way (yet). Plugging/unplugging AC power doesn't wake it up. If you wish to sleep and carry, you need to unplug all necessary USB devices first before sleeping. I personally wouldn't put my precious machine in a backpack/bag on sleep using macOS, but to be fair, I wouldn't do this with Windows or Linux either. I always shutdown before transporting.





## Other Functions

### Realtek ALC295 Audio Fixes

The Realtek ALC295 has two issues (which can both be fixed):

- Audio input doesn't switch from **Internal Microphone** to **Line In** when plugging in a headset with a mic.
- The audio has static noise in the left earphone

The mic switching problem can be fixed by modifying the ***Audio Plug Fix\*** to work with the Realtek ALC295.



The static noise problem also occurs in Linux and I have posted a fix which can be used in Linux until it is incorporated into the Linux kernel. The same fix can be used in macOS. It involves executing the ***hda-verb\*** command upon startup and wake up. Since the Audio Plug Fix also uses the ***hda-verb\*** command and runs upon start up and wake up, it is very convenient to simply incorporate the static noise fix into the ***Audio Plug Fix\****. I have done so and the compiled fix is available in the zip file. Please note it is best practice to take the original source (which may have updates), do the modifications and recompile. The readme.txt file I have created in the zip provides instructions to do all this.



To install my compilation of the ***Audio Plug Fix\*** which includes the static noise fix, do the following:

1. Make sure CodeCommander.kext is installed in macOS.
2. Test that ***hda-verb\*** is working as follows: in the folder ALCPlugFixforRealtekACL2915/alc_fix , run the program ***hda-verb\*** by double-clicking on it in ***Finder\***. Give it permissions if needed and make sure it runs in a **Terminal**. It should report "[Process completed]". The window can be closed.
3. Test that ***ALCPlugFix\*** is detecting plugging/unplugging as follows: in the folder ALCPlugFixforRealtekACL2915/alc_fix , run the program ***ALCPlugFix\*** by double-clicking on it in ***Finder.\*** It should display a **Terminal**. Every time you plug/unplug a headset, it should respond to a plugging/unplugging event with text output "Audio device changed!" and "Fixing...". The window can be closed.
4. Install as follows: open a ***Terminal\*** in the ALCPlugFixforRealtekACL295/alc_fix folder and run the command sh install.sh (password required). This will install the program to run as a background process which will run at start up.
5. In ***System Preferences\*** > Sound > Input, check that plugging/unplugging a headset switches between **Internal Microphone** and **Line In**. Adjust the Line In **input volume**. On my machine, with my headsets, it needs to be at around 95%.

  \* The actual ***hda-verb\*** commands that are run are as follows:

hda-verb 0x19 SET_PIN_WIDGET_CONTROL 0x24

hda-verb 0x20 SET_COEF_INDEX 0x67

hda-verb 0x20 SET_PROC_COEF 0x3000



### Realtek RTS522A PCIe Card Reader

There is a card reader kext called Sinetek-rtsx.kext which is in early development. If you have issues, you can use a USB card reader. I have tested one, and it works without any problems.

To work with my card I need to change the kext's Info.plist file to have the IOPCIMatch value set to **0x522A10EC**. However, neither the source build nor my own refresh build from the source using Xcode worked on my machine. Installing the kext causes a reboot and subsequent reboots on logon. I found a build that contains what seems to be the same kext, but it works on machine (I don't know what the difference is).

You can download it and change the value as described above or use my copy.

When installed, there is no mention of the card reader in System Report - hardware, but I can see the kext present in System Report - Software - Extensions. Disk Utility shows the device as an external device called "RTSX SD Card Reader Media Media"

Using it between Windows and macOS works fine. I can reformat in Windows or macOS with no issues. Copying files, etc works fine. However I have found some problems. If I mount my SD card in Linux, macOS can't read it. If I subsequently mount the SD card in Windows and then try macOS it struggles - I then "force eject" the card and remount it and it all works fine.
