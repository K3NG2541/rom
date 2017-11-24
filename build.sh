#!/usr/bin/env bash

# Script to build Los14.1 For Lenovo P1m

git clone https://github.com/K3NG2541/android_device_lenovo_P1m -b cm-14.1 device/lenovo/P1m
git clone https://github.com/K3NG2541/android_vendor_lenovo_P1m -b cm-14.1 vendor/lenovo/P1m
git clone https://github.com/K3NG2541/android_kernel_lenovo_P1m -b master kernel/lenovo/P1m
cd device/lenovo/P1m/patches
bash apply-patches.sh
export CCACHE_DIR=./.ccache
ccache -C
export USE_CCACHE=1
export CCACHE_COMPRESS=1
prebuilts/misc/linux-x86/ccache/ccache -M 50G
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
./prebuilts/sdk/tools/jack-admin kill-server
./prebuilts/sdk/tools/jack-admin start-server
export USE_NINJA=false
make clean && make clobber
source build/envsetup.sh
lunch lineage_P1m-userdebug
brunch lineage_P1m-userdebug