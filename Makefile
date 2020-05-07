#
# Copyright (C) 2020 Mark Ong <hquu@outlook.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-dns-forwarder
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Mark Ong <hquu@outlook.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-dns-forwarder
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI Support for dns-forwarder
	PKGARCH:=all
	DEPENDS:=+dns-forwarder
endef

define Package/luci-app-dns-forwarder/description
	LuCI Support for dns-forwarder.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/files/luci/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-dns-forwarder/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	if [ -f /etc/uci-defaults/luci-dns-forwarder ]; then
		( . /etc/uci-defaults/luci-dns-forwarder ) && \
		rm -f /etc/uci-defaults/luci-dns-forwarder
	fi
	rm -rf /tmp/luci-indexcache
fi
exit 0
endef

define Package/luci-app-dns-forwarder/postrm
#!/bin/sh
rm -f /tmp/luci-indexcache
exit 0
endef

define Package/luci-app-dns-forwarder/conffiles
/etc/config/dns-forwarder
endef

define Package/luci-app-dns-forwarder/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/dns-forwarder.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/usr/share/rpcd/acl.d/* $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/luci/controller/dns-forwarder.lua $(1)/usr/lib/lua/luci/controller/dns-forwarder.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/luci/model/cbi/dns-forwarder.lua $(1)/usr/lib/lua/luci/model/cbi/dns-forwarder.lua
endef

$(eval $(call BuildPackage,luci-app-dns-forwarder))
