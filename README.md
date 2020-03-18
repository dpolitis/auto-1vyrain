Software-based "jailbreak" allowing all ivybridge-based xx30 thinkpads to softmod custom bios images.

This repo contains the necessary files to build the bootable image yourself and not rely on binary blobs.

## Read the [long form FAQ](https://medium.com/@n4ru/1vyrain-an-xx30-thinkpad-jailbreak-fd4bb0bdb654).

# Features:
- Automatic exploit chain unlocking bios region for flashing
- Model detection and automatic bios flashing
- Support for custom bios images (coreboot, skulls, heads)

# BIOS Mod Features:
- Overclocking support (37xx, 38xx, 39xx CPUs)
- Whitelist removal to use any WLAN adapter
- Advanced menu (custom fan curve, TDP, etc)
- Intel ME disablement via advanced menu
- LVDS patch for x230 FHD mod

# Before Installing
**Please pay careful attention to this section.** . Ensure you're on a compatible BIOS version before beginning (check compatability [here](https://github.com/gch1p/thinkpad-bios-software-flashing-guide#bios-versions)). Run [IVprep](https://github.com/n4ru/IVprep) if you are not or are unsure. Clear any BIOS passwords or settings prior to flashing, and do a BIOS setting reset if you can. Ensure your ThinkPad is charged and your adapter is plugged in. If you intend to use a custom image, make sure you plug in ethernet prior to boot and that your image is directly accessible via URL.

# Supported Systems
- X230
- X330*
- X230t
- T430
- T430s
- T530
- W530

*X330 machines are supported but not automatically detected. They are detected as normal X230 machines. The flashing menu has an additional option to flash a BIOS with the LVDS patch for machines detected as an X230. Main difference with [1vyrain](https://github.com/n4ru/1vrain) compiled image is that my patch wipes out LVDS output from bios, mainly for nitrocaster's mod to work properly.*

# Supporting New Systems and Opening Issues
Please read the [longform FAQ](https://medium.com/@n4ru/1vyrain-an-xx30-thinkpad-jailbreak-fd4bb0bdb654).

# Installing

1. Build Docker image:
   ```console
   docker build --rm -t 1vyrain:v1.0 .
   ```
2. Run Docker container to get bootable iso image in "result" folder.
   ```console
   docker run -d --rm -v /dev:/dev -v $PWD/result:/workspace/result --privileged -t 1vyrain:v1.0
   ```
3. Burn the 1vyrain image onto a flash drive.
4. Boot in UEFI mode from the flash drive, with Secure Boot off.
5. Follow the on-screen instructions.
6. That's it!

# License

All the code in this repo, excluding n4ru's Original README.me, is licenced under GPLv3.

---

# Credits

This was a fun work to do over a free weekend.

Many thanks to [n4ru](https://1vyra.in/) for the original idea and his tutorials:
https://medium.com/@n4ru/1vyrain-an-xx30-thinkpad-jailbreak-fd4bb0bdb654
https://medium.com/@n4ru/1vyrain-self-build-documentation-5059825b1fdb

Huge thanks go out to [gch1p](https://github.com/gch1p/thinkpad-bios-software-flashing-guide) for publishing the method used and [pgera](https://github.com/hamishcoleman/thinkpad-ec/issues/70#issuecomment-417903315) for the working commands, without them this would have not been possible.

# Mini FAQ

- Man, the image is ready with all bells and whistles. Why the hassle?
Because Iam THAT guy. I do not trust peoples's binaries blindly (and maybe you shouldn't too).

- Does this work with T430?
No unless you soldered a proper bios chip on it. I do not currently have the required patch for flashrom. You can use the original precompiled image of n4ru for that (for now).

- Does it contain a patch for x230 FHD mod?
Yes, choose X330, when asked.

- What is the root password for the image?
There is no autologin for failsafe reasons. On the login prompt just type "root" and press enter twice (empty pass).

- Can I download 1vyprep images from Lenovo my self, also?
Yes you can. Run the 1vyprep-get-roms.sh on the scripts folder. There is also a bat file to burn images (1vprep.bat), using a win x64 bootable cd.

**UPDATE: You can now use the automated method of creating a mini bootable windows 10 iso to auto-apply 1vyprep. More info here:** [auto-1vyprep](https://github.com/dpolitis/auto-1vyprep)

- Can I see the patches applied?
Yes, see the patcher/patcher.sh script.

- I created the image  just fine, but unfortunatelly chipsec does not run and complains about something an .ko module thingie..
Hm, yes. chipsec builds a kernel module that uses to do its magic. If you build this image on docker running different kernel version, you might get an invalid format error (or not), YMMV. The safe bet here is to run docker on a latest fedora system (31, as of now) with all updates installed. This can of course be a bare metal or VM system.
