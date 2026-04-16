### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=GKI kernel by Jianke 1078380389
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=1
device.name1=
device.name2=
device.name3=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot shell variables
block=boot
is_slot_device=auto
ramdisk_compression=auto
patch_vbmeta_flag=auto
no_magisk_check=1


# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

# boot install
split_boot
flash_boot
## end boot install


ui_print "   GKI 系列内核        ";
ui_print "   Kernel by Jianke   ";
ui_print "   内核交流群1078380389 ";
