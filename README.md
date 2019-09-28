# OpenCore and Gigabyte Z170X-Gaming 5 based Customac

This is to document the software part of a Customac build using [OpenCore bootloader](https://github.com/acidanthera/OpenCorePkg), especially the OC folder in the EFI System Partition of my SSD.

This OpenCore setup takes profit from [the experience I gained with the same hardware, but with the Clover bootloader](https://github.com/barijaona/CLOVER_GA-Z170X-Gaming5).

The motivation for the switch to OpenCore was improved memory management with recent boards, especially those with AMI Aptio firmwares like the one I use. This makes certain features, like hibernation and FileVault which rely on NVRam, much more reliable.

### Philosophy of the project

I try to maintain a vanilla macOS installation. Main partition should remain identical to that of an official Apple computer, and the bulk of the hacks needed to make the hardware run smoothly are contained on the EFI partition.

This should allow upgrading of the system as soon as Apple issues a macOS update, without wondering too much.

SIP is enabled like in a stock Mac.

### Hardware

To sumarize the hardware used :

- Motherboard : Gigabyte GA-Z170X-Gaming 5 (rev 1.0)
- CPU : Intel Skylake Core i5-6600K 3.5 - 3.9 GHz
- Graphics card : PowerColor RadeonRX580
- Wifi/Bluetooth : built from a genuine Apple Airport card, which uses a BCM94360CD chipset.

### Points which require personalization

#### BIOS

This board is notoriously picky regarding memory, so you might have to configure the BIOS with a single memory stick at first. I currently use BIOS F20, which runs OK after forcing the board to stick to the memory speed of 2133 MHz during initial startup.

Most settings can be seen in this [photo album](https://www.flickr.com/photos/barijaona/albums/72157683707850861 "A Flickr photo album").

#### USB

This motherboard has a lot of USB ports. This is more than macOS can natively handle. To have a reliable and easily upgradable machine, you must compromise and block the use of some of the physical ports, in order to respect a 15 ports limit inherent to macOS's controller.

Other approaches have been explored and are explained in [a discussion](https://github.com/barijaona/CLOVER_GA-Z170X-Gaming5/issues/9#issuecomment-305057990) regarding my previous configuration, but hereafter is my current recommandation for setting up USB on this motherboard.  
You will need to:

- download the [full archive of the GA\_Z170X\_G5\_Injector.kext](https://github.com/barijaona/barijaona.github.io/blob/master/macintosh/Jirokaki/GA-Z170X-Gaming5-USBinjector.zip),
- make your ports choice with the help of the included drawings, in order to respect the logical limit of 15 ports. It must be noted that physical USB3 ports use 2 logical ports: one for USB2 and one for USB3.
- once you have made your choice, prune the Info.plist file included inside the .kext and put the modified GA\_Z170X\_G5\_Injector.kext into the `Kexts` folder.

Another possible approach for customizing USB would be to use [USBMap](https://github.com/corpnewt/USBMap).

#### CPU

I use dynamic power management injection to enable HWP (Intel Speed Shift).

If you have another CPU model than the one I use, you might need to run  [ssdtPRGen.sh](https://github.com/Piker-Alpha/ssdtPRGen.sh) to generate your own version of SSDT-CPU.aml in order to inject a `One` plugin-type, enable Apple's X86PlatformPlugin.kext and therefore take full advantage of your processor. Afterward, you may have to add a `cf-frequency-data` entry into the above mentioned SSDT to enable HWP and set frequency vectors.

More details can be found at instructions for [CPUFriend installation](https://github.com/acidanthera/CPUFriend/blob/master/Instructions.md).

If you find this a bit complex, just disable/remove `SSDT-CPU.aml` and `CPUFriend.kext`.

#### iMessage, iTunes, AppStore…

For privacy reasons, some personal informations (specifically machine's serial numbers) are hidden from this repository.

Personally, I just reused data from my Clover configuration :

- `BoardSerialNumber` in Clover's config.plist becomes the `MLB` in OpenCore's Config.plist
- `SerialNumber` becomes `SystemSerialNumber`
- `SmUUID` becomes `SystemUUID`.

If you want to generate your own serial numbers, you will have to follow the instructions regarding PlatformInfo [provided at the OpenCore Vanilla Desktop Guide](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/) for the relevant processor family. This details the use of acidanthera's [macserial](https://github.com/acidanthera/MacInfoPkg) application.

### Additional notes

For increased legitibility, sources or .dsl of DSDT/SSDT patches (which are .aml files in the `ACPI` folder) are available in the `Sources-ACPI` folder.

### About license

This work is published for informational use only. Any component shown here retains its own licence.
