#!/bin/bash
echo "Making Directory to sync AICP sources"
cd ~
mkdir AICP
cd AICP
echo "Enter Username and Email Github"
git config --global user.name
git config --global user.email
echo "Preparing to sync"
repo init -u https://github.com/AICP/platform_manifest.git -b n7.1
repo sync -c -f --force-sync --no-clone-bundle --no-tags -j64
echo "Sync complete Syncing device repos"
git clone https://github.com/K3NG2541/android_device_lenovo_P1m -b aicp device/lenovo/P1m
git clone https://github.com/K3NG2541/android_kernel_lenovo_P1m kernel/lenovo/P1m
git clone https://github.com/K3NG2541/android_vendor_lenovo_P1m vendor/lenovo/P1m
echo "Apply Patches"
cd device/lenovo/P1m/patches
sudo bash apply-patches.sh
echo "Fix Sepolicy"
rm -r system/sepolicy
git clone https://github.com/K3NG2541/system_sepolicy.git -b P1m-7.1 system/sepolicy
echo "set up to build"
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
. build/envsetup.sh
lunch aicp_P1m-userdebug
brunch aicp_P1m-userdebug
