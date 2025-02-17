ANDROID_BUILD_TOP="/crave-devspaces/android/lineage"

# download gta4xl related files
source build/envsetup.sh
breakfast gta4xl

rm $ANDROID_BUILD_TOP/kernel/samsung/gta4xl/arch/arm64/exynos9611-gta4xl_defconfig
wget https://github.com/revantTNK/bs/blob/main/exynos9611-gta4xl_defconfig -P $ANDROID_BUILD_TOP/kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig

KERNEL_VERSION=$(grep -E '^VERSION' kernel/samsung/gta4xl/Makefile | cut -d' ' -f3)
PATCHLEVEL=$(grep -E '^PATCHLEVEL' kernel/samsung/gta4xl/Makefile | cut -d' ' -f3)

sed -i '/# CONFIG_SYSVIPC is not set/d' $ANDROID_BUILD_TOP/kernel/configs/*/android-${KERNEL_VERSION}.${PATCHLEVEL}/android-base.config

echo "$(call inherit-product, vendor/lindroid/lindroid.mk)" > device/samsung/gta4xl/device.mk

cd $ANDROID_BUILD_TOP/frameworks/native
wget https://github.com/LMODroid/platform_frameworks_native/commit/51b680f33b66e06b18725fdf9a54fa923c14a10b.patch
git am 51b680f*.patch
cd $ANDROID_BUILD_TOP

echo "BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive" > $ANDROID_BUILD_TOP/device/samsung/gta4xl/BoardConfig.mk

# build using userdebug

cd $ANDROID_BUILD_TOP
croot
brunch gta4xl userdebug
