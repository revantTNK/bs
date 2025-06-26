crave clone create --projectID 72 /crave-devspaces/lineage21

## vars
ANDROID_BUILD_TOP=/crave-devspaces/lineage21

## cd to lineage sources dir
cd $ANDROID_BUILD_TOP

## clone device-specific files
source build/envsetup.sh
breakfast gta4xl

## clone in lindroid-specific repositories
git clone https://github.com/Linux-on-droid/vendor_lindroid -b lindroid-21 vendor/lindroid
git clone https://github.com/Linux-on-droid/external_lxc external/lxc
git clone https://github.com/Linux-on-droid/libhybris libhybris

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


