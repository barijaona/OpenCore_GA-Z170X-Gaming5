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

This board is notoriously picky regarding memory, so you might have to configure the BIOS with a single memory stick at first. I currently use BIOS F22f, which runs OK as far as the memory sticks use the two slots nearest to the CPU. Your mileage may vary…

Most settings can be seen in this [photo album](https://www.flickr.com/photos/barijaona/albums/72157683707850861 "A Flickr photo album").

The OpenCore documentation recommends that the setup allows macOS to unlock the `0xE2` registry. My configuration won't boot without this (I haven't tested the `AppleCpuPmCfgLock` and `AppleXcpmCfgLock` quirks). As a `CFG Lock` option is available in the firmware, but is hidden from the BIOS GUI, I included a GRUB shell [modified by <i>datasone</i>](https://github.com/datasone/grub-mod-setup_var "A modified grub allowing tweaking hidden BIOS settings") to access this option.

Therefore, for this motherboard and BIOS F20 or F22f, you will have to access this GRUB shell through the initial menu, type the command `setup_var 0x4EF 0x00`, and reboot afterwards. For other motherboards or other version of BIOSes, the OpenCore documentation explains how to find the correct value.

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

Note that while Intel Skylake processors support HWP, Apple does not implement it with iMac17,1 configuration. So, I had to [hack a litle bit to generate frequency data derived from one used by MacBook9,1](https://github.com/barijaona/OpenCore_GA-Z170X-Gaming5/commit/492580325d94d4b6e30c637626880df3bcbb7188 "Commit 4925803 committed 10 May 2020").

If you intend to use the same SMBIOS and have a non-Skylake CPU, you will probably have to modify the `cf-frequency-data` entry into SSDT-CPU.aml. More details can be found at instructions for [CPUFriend installation](https://github.com/acidanthera/CPUFriend/blob/master/Instructions.md).

If you find this a bit complex, just disable/remove `SSDT-CPU.aml` and `CPUFriend.kext`.

#### iMessage, iTunes, AppStore…

For privacy reasons, some personal informations (specifically machine's serial numbers) are hidden from this repository.

Personally, I just reused data from my Clover configuration :

- `BoardSerialNumber` in Clover's config.plist becomes the `MLB` in OpenCore's Config.plist
- `SerialNumber` becomes `SystemSerialNumber`
- `SmUUID` becomes `SystemUUID`.

If you want to generate your own serial numbers, you will have to follow the instructions regarding PlatformInfo [provided at the OpenCore Vanilla Desktop Guide](https://khronokernel-2.gitbook.io/opencore-vanilla-desktop-guide/) for the relevant processor family. This details the use of acidanthera's [macserial](https://github.com/acidanthera/MacInfoPkg) application.

### Additional notes

Be safe ! A syntax error in your `Config.plist` may block booting:

- always backup your working `Config.plist` to `Config.sav`
- after any modification of `Config.plist`, check it by running the `ocvalidate` tool (provided within OpenCore's 'Utilities' folder) with the file as an argument.
- remain prepared with [a USB stick with a UEFI shell](https://kc.mcafee.com/corporate/index?page=content&id=KB90801&locale=en_US "How to create a bootable USB media to access the default EFI shell") to be able to restore from `Config.sav`

Note that before upgrading to a new macOS version (for instance, going from 10.15.0 to 10.15.1), it is recommended to update [Lilu](https://github.com/acidanthera/Lilu/releases), the [relevant Lilu plugins](https://github.com/acidanthera/Lilu/blob/master/KnownPlugins.md), then [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg/releases).

For increased legitibility, sources or .dsl of DSDT/SSDT patches (which are .aml files in the `ACPI` folder) are available in the `Sources-ACPI` folder.

### About license

This work is published for informational use only. Any component shown here retains its own licence.
