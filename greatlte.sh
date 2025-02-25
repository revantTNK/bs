ANDROID_BUILD_TOP="/crave-devspaces/test2"

cd $ANDROID_BUILD_TOP

#download greatlte roomservice file as failsafe if repo cloning doesnt work
git clone https://github.com/ivanmeler/local_manifests -b android-14 .repo/local_manifests

repo sync -c

# pull files since breakfast is not being eaten anymore
git clone https://github.com/8890q/android_device_samsung_greatlte -b lineage-21 device/samsung/greatlte
git clone https://github.com/8890q/android_device_samsung_universal8895-common -b lineage-21 device/samsung/universal8895-common
git clone https://github.com/8890q/android_kernel_samsung_universal8895 -b lineage-21-rel kernel/samsung/universal8895
git clone https://github.com/8890q/proprietary_vendor_samsung -b lineage-21.0 vendor/samsung
git clone https://github.com/8890q/android_device_samsung_slsi_sepolicy -b lineage-21 device/samsung_slsi/sepolicy
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_config hardware/samsung_slsi-linaro/config -b lineage-20 
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_exynos -b lineage-21 hardware/samsung_slsi-linaro/exynos
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_exynos5 -b lineage-20 hardware/samsung_slsi-linaro/exynos5
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_graphics -b ineage-21 hardware/samsung_slsi-linaro/graphics
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_openmax -b lineage-20 hardware/samsung_slsi-linaro/openmax
git clone https://github.com/8890q/android_hardware_samsung -b lineage-21 hardware/samsung

# pull device specific files since it doesnt work without it
source build/envsetup.sh
breakfast greatlte

# lindroid sauce
git clone https://github.com/Linux-on-droid/vendor_lindroid vendor/lindroid
git clone https://github.com/Linux-on-droid/external_lxc external/lxc
git clone https://github.com/Linux-on-droid/libhybris libhybris

# patch
cd $ANDROID_BUILD_TOP/frameworks/native
wget https://github.com/LMODroid/platform_frameworks_native/commit/51b680f33b66e06b18725fdf9a54fa923c14a10b.patch
git am 51b680f*.patch
cd $ANDROID_BUILD_TOP

# KERNEL CONFIGS, DEVICE.MK AND BOARDCONFIG.MK SHOULD HAVE ALREADY BEEN EDITED BY NOW
# IGNORE THE ABOVE COMMENT
cd $ANDROID_BUILD_TOP/kernel/samsung/universal8895/arch/arm64/configs
rm exynos8895-greatlte_defconfig
wget https://github.com/revantTNK/bs/raw/refs/heads/main/exynos8895-greatlte_defconfig 
cd $ANDROID_BUILD_TOP

# boardconfig
cd $ANDROID_BUILD_TOP/device/samsung/greatlte
rm BoardConfig.mk
wget https://github.com/revantTNK/bs/raw/refs/heads/main/BoardConfig.mk
cd $ANDROID_BUILD_TOP

# building magic, hopefully
croot
brunch greatlte userdebug

exit 0

