## vars
ANDROID_BUILD_TOP=/crave-devspaces/lineage21

## cd to lineage sources dir
cd $ANDROID_BUILD_TOP
repo sync -c

## clone device-specific files
source build/envsetup.sh
breakfast gta4xl

## clone in lindroid-specific repositories
git clone https://github.com/Linux-on-droid/vendor_lindroid -b lindroid-21 vendor/lindroid
git clone https://github.com/Linux-on-droid/external_lxc external/lxc
git clone https://github.com/Linux-on-droid/libhybris libhybris

## clone in device vendor files, might automate by adding TheMuppets manifest in the future
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_gta4xl vendor/samsung/gta4xl -b lineage-21
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_gta4xl-common vendor/samsung/gta4xl-common -b lineage-21

## patch lineageos framework to work with lindroid
cd $ANDROID_BUILD_TOP/frameworks/native
wget https://github.com/LMODroid/platform_frameworks_native/commit/51b680f33b66e06b18725fdf9a54fa923c14a10b.patch
git am 51b680f*.patch
cd $ANDROID_BUILD_TOP

## mk file patchy patchy
echo "\$(call inherit-product, vendor/lindroid/lindroid.mk)" >> $ANDROID_BUILD_TOP/device/samsung/gta4xl/device.mk
echo "BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive" >> $ANDROID_BUILD_TOP/device/samsung/gta4xl/BoardConfig.mk

## hocus pocus bullshit on the defconfig, hope it works
echo "CONFIG_SYSVIPC=y" >> $ANDROID_BUILD_TOP/kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo "CONFIG_IPC_NS=y" >> $ANDROID_BUILD_TOP/kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo "CONFIG_USER_NS=y" >> $ANDROID_BUILD_TOP/kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo "CONFIG_CGROUP_FREEZER=y" >> $ANDROID_BUILD_TOP/kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig

## build!!! inshallah it will work
brunch gta4xl userdebug
