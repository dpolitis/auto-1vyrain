lang en_US.UTF-8
keyboard us
timezone US/Eastern
auth --useshadow --passalgo=sha512
rootpw --iscrypted $6$IofbdE7LaRem0MPo$O/ZoYrgFxt/l9ToTkl7hJSIzZ3hSjNQo2TAYPPsKJaCzt/R6h7jsH1dcOEWuy46VkMw.eePYN7QDtAveV16Fx0
selinux --enforcing
firewall --enabled
clearpart --drives=sd*|hd*|vd* --all --initlabel --disklabel=gpt
part /boot/efi --fstype=efi --grow --maxsize=128 --size=20
part / --size 2048
bootloader --location=partition --append="iomem=relaxed nopti noibrs noibpb"

repo --name=fedora --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=fedora-updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch


%packages --excludedocs
@Core
kernel
dracut-live
python2-pip
authselect-compat
grub2-efi-x64
grub2-efi-x64-cdboot
shim-x64
wget
isomd5sum
dmidecode
pciutils-libs
libusb
libjaylink
libftdi
-openssh-server
-libX*
-btrfs-progs
-parted
-snappy
-trousers
-avahi-libs
%end

%post
wget -r -P /root http://localhost:8080/
mv /root/localhost\:8080 /root/workspace
cp -r /root/workspace/flashrom /root/flashrom
chmod +x /root/flashrom/flashrom
cp -r /root/workspace/bios /root/bios
pip2 install /root/workspace/chipsec/*.whl
mkdir /root/chipsec
ln -s /usr/bin/chipsec_util /root/chipsec/chipsec_util.py
ln -s /usr/bin/chipsec_main /root/chipsec/chipsec_main.py
cp /root/workspace/scripts/start.sh /root/start.sh
rm -rf /root/workspace
find /root -type f -name "index.html" -delete
printf "\nif [ -f ~/.bashrc ]; then\n\tchmod +x ~/start.sh\n\t~/start.sh\nfi\n\nexport updated=r3\n" >> /root/.bashrc
systemctl mask NetworkManager-wait-online.service
%end
