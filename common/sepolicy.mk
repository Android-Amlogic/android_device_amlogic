ifneq ($(TARGET_BUILD_CTS), true)

BOARD_SEPOLICY_DIRS := \
    device/amlogic/common/sepolicy
else
BOARD_SEPOLICY_DIRS := \
    device/amlogic/common/sepolicy_cts
endif

BOARD_SEPOLICY_REPLACE := \
    domain.te

BOARD_SEPOLICY_UNION := \
    device.te \
    file.te \
    file_contexts \
    genfs_contexts \
    gpsd.te \
    imageserver.te \
    init.te \
    kernel.te \
    recovery.te \
    mediaserver.te \
    netd.te \
    property_contexts \
    property.te \
    ppp.te \
    remotecfg.te \
    service.te \
    service_contexts \
    servicemanager.te \
    system_app.te \
    system_control.te \
    system_server.te \
    unlabeled.te \
    vold.te \
    vold_ext.te \
    pppd.te \
    pppoe_wrapper.te \
    rild.te \
    modem_dongle_d.te \
    wlan_fwloader.te \
    zygote.te \
    surfaceflinger.te \
    zygote_proxy.te \
    bootanim.te \
    bootvideo.te \
    platform_app.te \
    instaboot.te \
    tvserver.te \
    tvcp.te \
    param.te \
    app.te \
    installd.te \
    lmkd.te \
    usbpm.te \
    seapp_contexts \
    hdcp_tx22.te

