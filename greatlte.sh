ANDROID_BUILD_TOP="/crave-devspaces/test2"

repo sync -c

#Pull device specific data
source build/envsetup.sh
breakfast greatlte


# pull files since breakfast is not being eaten anymore
git clone https://github.com/8890q/proprietary_vendor_samsung -b lineage-21.0 vendor/samsung
git clone https://github.com/8890q/android_device_samsung_slsi_sepolicy -b lineage-21 device/samsung_slsi/sepolicy
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_config hardware/samsung_slsi-linaro/config -b lineage-20 
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_exynos -b lineage-21 hardware/samsung_slsi-linaro/exynos
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_exynos5 -b lineage-20 hardware/samsung_slsi-linaro/exynos5
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_graphics -b ineage-21 hardware/samsung_slsi-linaro/graphic
git clone https://github.com/8890q/android_hardware_samsung_slsi-linaro_openmax -b lineage-20 hardware/samsung_slsi-linaro/openmax
git clone https://github.com/8890q/android_hardware_samsung -b lineage-21 hardware/samsung

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

# building magic, hopefully
croot
brunch greatlte

exit 0

