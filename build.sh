#!/usr/bin/env bash

ANDROID_BUILD_TOP="/crave-devspaces/lindroid"

# Create Lindroid and TheMuppets manifests
mkdir -p .repo/local_manifests/
wget https://raw.githubusercontent.com/Soupborsh/Lindroid-files/refs/heads/main/manifests/general/lindroid.xml -O .repo/local_manifests/lindroid.xml

# TheMuppets
echo '<?xml version="1.0" encoding="UTF-8"?>' > .repo/local_manifests/muppets.xml
echo '<manifest>' >> .repo/local_manifests/muppets.xml
echo "  <project name=\"TheMuppets/proprietary_vendor_samsung_gta4xl\" path=\"vendor/samsung/gta4xl\" revision=\"lineage-21\" clone-depth=\"1\" />" >> .repo/local_manifests/muppets.xml
echo '</manifest>' >> .repo/local_manifests/muppets.xml

#Pull device specific data
source build/envsetup.sh
breakfast gta4xl

# pull unavailable vendor files
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_gta4xl -b lineage-21 vendor/samsung/gta4xl
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_gta4xl-common -b lineage-21 vendor/samsung/gta4xl-common

# replace device.mk because sed hates dollar symbols and im mad now 
wget https://github.com/revantTNK/bs/raw/refs/heads/main/device.mk -P device/samsung/gta4xl/

# Patches
## Linux kernel defconfig
sed -i '/CONFIG_SYSVIPC/d' kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
sed -i '/CONFIG_UTS_NS/d' kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
sed -i '/CONFIG_PID_NS/d' kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
sed -i '/CONFIG_IPC_NS/d' kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
sed -i '/CONFIG_USER_NS/d' kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
sed -i '/CONFIG_NET_NS/d' kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
sed -i '/CONFIG_CGROUP_DEVICE/d' kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
sed -i '/CONFIG_GROUP_FREEZER/d' kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig

echo 'CONFIG_SYSVIPC=y' >> kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo 'CONFIG_UTS_NS=y' >> kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo 'CONFIG_PID_NS=y' >> kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo 'CONFIG_IPC_NS=y' >> kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo 'CONFIG_USER_NS=y' >> kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo 'CONFIG_NET_NS=y' >> kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo 'CONFIG_CGROUP_DEVICE=y' >> kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig
echo 'CONFIG_GROUP_FREEZER=y' >> kernel/samsung/gta4xl/arch/arm64/configs/exynos9611-gta4xl_defconfig

## Download patch
cd $ANDROID_BUILD_TOP/frameworks/native
wget https://github.com/LMODroid/platform_frameworks_native/commit/51b680f33b66e06b18725fdf9a54fa923c14a10b.patch

## Apply patch
git am 51b680f*.patch
cd $ANDROID_BUILD_TOP

## Remove patch file
rm $ANDROID_BUILD_TOP/frameworks/native/51b680f33b66e06b18725fdf9a54fa923c14a10b.patch

# Fix building by removing CONFIG_SYSVIPC from android-base.config
KERNEL_VERSION=$(grep -E '^VERSION' kernel/samsung/gta4xl/Makefile | cut -d' ' -f3)
PATCHLEVEL=$(grep -E '^PATCHLEVEL' kernel/samsung/gta4xl/Makefile | cut -d' ' -f3)

sed -i '/# CONFIG_SYSVIPC is not set/d' kernel/configs/*/android-${KERNEL_VERSION}.${PATCHLEVEL}/android-base.config

# Build
croot
brunch gta4xl userdebug

exit 0
