# AnyKernel3/modules.sh

mkdir -p /data/adb/modules/fujiamukuai
chmod 755 /data/adb/modules/fujiamukuai

cp -f $AK3/lunar_bsp_ext_sched.ko /data/adb/modules/fujiamukuai/
chmod 644 /data/adb/modules/fujiamukuai/lunar_bsp_ext_sched.ko

cat > /data/adb/modules/fujiamukuai/module.prop << 'EOF'
id=fujiamukuai
name=附加模块
version=1.0
author=fujiaf
description=附加模块加载来自Jianke
EOF

chmod 644 /data/adb/modules/fujiamukuai/module.prop
echo "#!/system/bin/sh" > /data/adb/modules/fujiamukuai/post-fs-data.sh
echo "insmod /data/adb/modules/fujiamukuai/lunar_bsp_ext_sched.ko" >> /data/adb/modules/fujiamukuai/post-fs-data.sh
chmod 755 /data/adb/modules/fujiamukuai/post-fs-data.sh
