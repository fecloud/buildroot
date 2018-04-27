################################################################################
#
# Rockchip Recovery For Linux
#
################################################################################

RECOVERY_SITE = $(TOPDIR)/../recovery
RECOVERY_VERSION = develop
RECOVERY_SITE_METHOD = local

RECOVERY_LICENSE_FILES = NOTICE
RECOVERY_LICENSE = Apache V2.0

RECOVERY_DEPENDENCIES = libdrm libpng

RECOVERY_BUILD_OPTS= \
	-I$(STAGING_DIR)/usr/include/libdrm \
	--sysroot=$(STAGING_DIR) \
	-fPIC

RECOVERY_MAKE = \
	$(MAKE) BOARD=$(BR2_ARCH) \

RECOVERY_MAKE_OPTS = \
	CC="$(TARGET_CC) $(RECOVERY_BUILD_OPTS)" \

define RECOVERY_CONFIGURE_CMDS
	# Do nothing
endef

define RECOVERY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(RECOVERY_MAKE) -C $(@D) \
		$(RECOVERY_MAKE_OPTS)
endef

define RECOVERY_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 755 $(@D)/recovery $(TARGET_DIR)/usr/bin/
endef

define RECOVERY_IMAGE_PACK
	$(HOST_DIR)/usr/bin/mkbootfs $(TARGET_DIR) | $(HOST_DIR)/usr/bin/minigzip > $(BINARIES_DIR)/ramdisk-recovery.img
endef

TARGET_FINALIZE_HOOKS += RECOVERY_IMAGE_PACK

$(eval $(autotools-package))