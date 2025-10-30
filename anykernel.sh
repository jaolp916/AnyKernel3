### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=GKI kernel by Jianke 190014252
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

## cmd output
print_output() {
    IFS=$'\n'
    eval "$1" | while read line; do
        ui_print "${line}"
    done
}

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

# boot install
split_boot
flash_boot
## end boot install

on_post_fs_data() {
    {
        ui_print "耐心等待"
        
        MODULE_PATH="$AKHOME/lunar_bsp_ext_sched.ko"
        
        if [ -f "$MODULE_PATH" ]; then
            ui_print "找到文件"
            
            if ! lsmod | grep -q "lunar_bsp_ext_sched"; then
                insmod "$MODULE_PATH"
                if [ $? -eq 0 ]; then
                    ui_print "加载成功"
                    echo 1 > /proc/sys/lunar_sched_ext/slim_walt_ctrl 2>/dev/null
                fi
            fi
        else
            ui_print "未找到文件: $MODULE_PATH"
        fi
        
    } > /dev/kmsg 2>&1
}

## install additional module
ui_print "Installing  module"
if [ -n "$(which magisk)" ]; then
    MAGISK_VER="$(magisk -v)"
    MAGISK_VERCODE="$(magisk -V)"
    (grep -q kitsune "$MAGISK_VER" || grep -q delta "$MAGISK_VER") && abort "Invalid magisk"
    [ "$MAGISK_VERCODE" -lt 28100 ] && abort "Magisk version too low"
    ui_print "Magisk: $MAGISK_VER($MAGISK_VERCODE)"
    print_output "magisk --install-module $AKHOME/magisk.zip"
elif [ -f "/data/adb/ksud" ]; then
    KSU_VER="$(/data/adb/ksud -V)"
    KSU_VERCODE="$(/data/adb/ksud debug version | awk -F': ' '{print $2}')"
    [ "$KSU_VERCODE" -lt 12081 ] && abort "KernelSU version too low"
    ui_print "KernelSU: $KSU_VER($KSU_VERCODE)"
    print_output "/data/adb/ksud module install $AKHOME/magisk.zip"
elif [ -f "/data/adb/apd" ]; then
    APATCH_VER="$(/data/adb/apd -V | awk -F' ' '{print $2}')"
    [ "$APATCH_VER" -lt 11039 ] && abort "APatch version too low"
    ui_print "APatch: $APATCH_VER"
    print_output "/data/adb/apd module install $AKHOME/magisk.zip"
    ui_print "After flash, you should reinstall APatch manually" && sleep 3
else
    abort "No module system not found"
fi


ui_print "   GKI 系列内核        ";
ui_print "   Kernel by Jianke   ";
ui_print "   内核交流群190014252  ";
