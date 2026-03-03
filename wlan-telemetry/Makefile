include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=telemetry-agent
PKG_VERSION:=0.1
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

ifneq ($(filter y,$(CONFIG_TARGET_sdx85_cpe-v1) $(CONFIG_TARGET_sdx85_cpe)),)
LOCAL_SRC:=$(TOPDIR)/src/ipq/qca-wifi/telemetry_agent
include $(TOPDIR)/owrt-qti-ipq-open/include/local-development.mk
else
include $(INCLUDE_DIR)/local-development.mk
LOCAL_SRC:=$(TOPDIR)/qca/src/qca-wifi/telemetry_agent
endif

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  TITLE:=Telemetry Agent
  DEPENDS+= kmod-ath12k
  FILES:=$(PKG_BUILD_DIR)/telemetry_agent.ko
endef

define KernelPackage/$(PKG_NAME)/description
	This package contains telemetry agent support for open source profile.
endef

MAKE_OPTS:= -C "$(PKG_BUILD_DIR)" \
	CROSS_COMPILE="$(KERNEL_CROSS)" \
	ARCH="$(LINUX_KARCH)" \
	EXTRA_CFLAGS="-Wall -Werror -Wno-unused-variable" \
	KERNEL_PATH="${LINUX_DIR}" \
	BUILD_PROFILE="Open" \
	KBUILD_EXTRA_SYMBOLS="$(STAGING_DIR)/usr/module-symbols/mac80211/Module.symvers" \
	PWD="$(PKG_BUILD_DIR)"
define Build/InstallDev
        $(CP) $(PKG_BUILD_DIR)/inc/telemetry_agent_app_if.h $(STAGING_DIR)/usr/include
endef

define Build/Compile
	$(KERNEL_MAKE) $(MAKE_OPTS) all
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
