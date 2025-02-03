include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=telemetry-agent
PKG_VERSION:=0.1
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

LOCAL_SRC:=$(TOPDIR)/qca/src/qca-wifi/telemetry_agent

# Get the dependency module from config or use default
DEPENDENCY_MODULE:=$(if $(CONFIG_TELEMETRY_AGENT_DEPENDENCY),$(CONFIG_TELEMETRY_AGENT_DEPENDENCY),ath12k)

include $(INCLUDE_DIR)/local-development.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
  TITLE:=Telemetry Agent
  DEPENDS+= +kmod-ath12k
  FILES:=$(PKG_BUILD_DIR)/telemetry_agent.ko
  # Use Autoload with no number prefix for alphabetical ordering
  AUTOLOAD:=$(call AutoLoad,,telemetry_agent)
  MENU:=1
endef

define KernelPackage/$(PKG_NAME)/config
	source "$(CURDIR)/Config.in"
endef

define KernelPackage/$(PKG_NAME)/description
	This package contains telemetry agent support for open source profile.
endef

MAKE_OPTS:= -C "$(PKG_BUILD_DIR)" \
	CROSS_COMPILE="$(KERNEL_CROSS)" \
	ARCH="$(LINUX_KARCH)" \
	EXTRA_CFLAGS="-Wall -Werror -Wno-unused-variable -I$(STAGING_DIR)/usr/include/mac80211/ath/" \
	KERNEL_PATH="${LINUX_DIR}" \
	BUILD_PROFILE="Open" \
	PWD="$(PKG_BUILD_DIR)"
define Build/InstallDev
        $(CP) $(PKG_BUILD_DIR)/inc/telemetry_agent_app_if.h $(STAGING_DIR)/usr/include
endef

define Build/Compile
	$(KERNEL_MAKE) $(MAKE_OPTS) all
endef

define KernelPackage/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/modules.d
	echo "telemetry_agent" > $(1)/etc/modules.d/54-$(PKG_NAME)
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
