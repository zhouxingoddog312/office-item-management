.PHONY:all release prepare create_dirs copy_files set_permissions clean distclean
#配置参数
#deb包命名主体
DEB_NAME:=office-item-management
#版本号
VERSION:=0.1.0
#架构
ARCH:=all
#deb包构建根目录
DEB_ROOT_DIR:=./release
#主程序路径
MAIN_PROG_SRC:=./oim.sh
#库函数路径
LIB_FILE_SRC:=./functions
#桌面文件路径
DESKTOP_SRC:=./oim.desktop
#目标主程序
MAIN_PROG_TARGET:=$(patsubst %.sh,%,$(notdir $(MAIN_PROG_SRC)))
#图标文件源目录
ICONS_SRC_DIR:=./src/icons
#目标图标文件统一命名
ICON_TARGET_NAME:=office-item-management.png
#图标文件所有尺寸
ICON_SIZES:=16x16 32x32 48x48 64x64 96x96 128x128 256x256 512x512

#默认目标
all:release

#构建deb包
release:prepare
	@echo "===开始构建deb包==="
	dpkg-deb -b $(DEB_ROOT_DIR) $(DEB_NAME)_$(VERSION)_$(ARCH).deb
	@echo "===deb包构建完成：$(DEB_NAME)_$(VERSION)_$(ARCH).deb==="
#打包前准备（创建目录，复制文件到指定位置，设置必要权限）
prepare:create_dirs copy_files set_permissions
	@echo "===打包前准备完成==="
#创建目录
create_dirs:
	@echo "===创建release目录结构==="
	mkdir -p $(DEB_ROOT_DIR)/usr/local/bin
	mkdir -p $(DEB_ROOT_DIR)/usr/share/applications
	$(foreach size,$(ICON_SIZES), \
		mkdir -p $(DEB_ROOT_DIR)/usr/share/icons/hicolor/$(size)/apps; \
	)
#复制文件到指定目录
copy_files:
	@echo "===复制文件到打包目录==="
#复制主程序到/usr/local/bin
	if [ -f "$(MAIN_PROG_SRC)" ];\
	then \
		cp -v $(MAIN_PROG_SRC) $(DEB_ROOT_DIR)/usr/local/bin/$(MAIN_PROG_TARGET);\
	else \
		echo "错误：主程序$(MAIN_PROG_SRC)不存在！" && exit 1;\
	fi
#复制库文件到/usr/local/bin
	if [ -f "$(LIB_FILE_SRC)" ];\
	then \
		cp -v $(LIB_FILE_SRC) $(DEB_ROOT_DIR)/usr/local/bin/$(notdir $(LIB_FILE_SRC));\
	else \
		echo "错误：库文件$(LIB_FILE_SRC)不存在！" && exit 1;\
	fi
#复制桌面文件到/usr/share/applications
	if [ -f "$(DESKTOP_SRC)" ];\
	then \
		cp -v $(DESKTOP_SRC) $(DEB_ROOT_DIR)/usr/share/applications/$(notdir $(DESKTOP_SRC));\
	else \
		echo "错误：桌面文件$(DESKTOP_SRC)不存在！" && exit 1;\
	fi
#复制图标文件到/usr/share/icons/hicolor（支持含尺寸子串的命名，如 icon_16x16.png）
	$(foreach size,$(ICON_SIZES), \
		icon_file=$$(find $(ICONS_SRC_DIR) -maxdepth 1 -type f -iname "*.png" -name "*$(size)*" | head -n 1);\
		if [ -n "$$icon_file" ];\
		then \
			cp -v "$$icon_file" $(DEB_ROOT_DIR)/usr/share/icons/hicolor/$(size)/apps/$(ICON_TARGET_NAME);\
		else \
			echo "警告：未找到尺寸为$(size)的图标，跳过该尺寸";\
		fi;\
	)
#设置文件权限主程序及库文件755,桌面文件644,图标文件644,control文件644,postinst等文件755
set_permissions:
	@echo "===设置文件权限==="
#主程序权限
	chmod 755 $(DEB_ROOT_DIR)/usr/local/bin/$(MAIN_PROG_TARGET)
#库文件权限
	chmod 755 $(DEB_ROOT_DIR)/usr/local/bin/$(notdir $(LIB_FILE_SRC))
#桌面文件权限
	chmod 644 $(DEB_ROOT_DIR)/usr/share/applications/$(notdir $(DESKTOP_SRC))
#图标文件权限
	$(foreach size,$(ICON_SIZES), \
		icon_path=$(DEB_ROOT_DIR)/usr/share/icons/hicolor/$(size)/apps/$(ICON_TARGET_NAME); \
		if [ -f "$$icon_path" ];\
		then \
			chmod 644 $$icon_path; \
		fi; \
	)
#其余文件权限
	chmod 755 $(DEB_ROOT_DIR)/DEBIAN/postinst
	chmod 644 $(DEB_ROOT_DIR)/DEBIAN/control
#清理生成的deb包
clean:
	@echo "===清理deb包==="
	rm -fv $(DEB_NAME)_$(VERSION)_$(ARCH).deb
#清理release中所有复制的文件，保留空目录
distclean:clean
	@echo "===彻底清理打包文件==="
#删除主程序
	rm -fv $(DEB_ROOT_DIR)/usr/local/bin/$(MAIN_PROG_TARGET)
#删除库文件
	rm -fv $(DEB_ROOT_DIR)/usr/local/bin/$(notdir $(LIB_FILE_SRC))
#删除桌面文件
	rm -fv $(DEB_ROOT_DIR)/usr/share/applications/$(notdir $(DESKTOP_SRC))
#删除图标文件
	$(foreach size,$(ICON_SIZES),\
		rm -fv $(DEB_ROOT_DIR)/usr/share/icons/hicolor/$(size)/apps/$(ICON_TARGET_NAME); \
	)
	@echo "===清理完成，可重新执行make构建==="
