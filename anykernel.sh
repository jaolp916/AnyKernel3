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
        
        MODULE_NAME="lunar_bsp_ext_sched.ko"
        MODULE_PATH="$AK3/$MODULE_NAME"
        
        if [ -f "$MODULE_PATH" ]; then
            ui_print "文件: $MODULE_PATH"

            if [ -s "$MODULE_PATH" ]; then
                ui_print "大小: $(stat -c%s "$MODULE_PATH") 字节"
                
                if ! lsmod | grep -q "lunar_bsp_ext_sched"; then
                    ui_print "正在加载..."
                    
                    insmod "$MODULE_PATH"
                    LOAD_RESULT=$?
                    
                    if [ "$LOAD_RESULT" -eq 0 ]; then
                        ui_print "加载成功"
                        
                        if [ -d "/proc/sys/lunar_sched_ext" ]; then
                            echo 1 > "/proc/sys/lunar_sched_ext/slim_walt_ctrl"
                            echo 120 > "/proc/sys/lunar_sched_ext/sched_ravg_window_frame_per_sec"
                        fi
                    else
                        ui_print "加载失败，错误码: $LOAD_RESULT"
                    fi
                else
                    ui_print "已加载"
                fi
            else
                ui_print "损坏"
            fi
        else
            ui_print "未找到文件"
            ui_print "$MODULE_PATH"
            
            ui_print "开发者模式"
            ui_print "内容:"
            ls -la "$AK3/" | grep -E "(ko|lunar)"
            
            ui_print "当前工作目录: $(pwd)"
            ui_print "AK3: $AK3"
            ui_print "RAMDISK_DIR: $RAMDISK_DIR"
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
