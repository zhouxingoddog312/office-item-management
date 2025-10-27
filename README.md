# 用于办公室用品管理
## 打包目录结构
release/  
├─ DEBIAN/                  # deb 包控制目录（含包管理必需的元文件，安装时不部署到系统）  
│  ├─ postinst              # 安装后执行脚本（动态生成：从 ./scripts/postinst.template 替换占位符得到，权限 755）  
│  ├─ postrm                # 卸载后执行脚本（动态生成：从 ./scripts/postrm.template 替换占位符得到，权限 755）  
│  └─ control               # deb 包元信息文件（动态生成：从 ./scripts/control.template 替换占位符得到，权限 644）  
│                           # （control 包含包名、版本、架构、依赖等核心信息，如 Package: {{DEB_NAME}}、Version: {{VERSION}}）  
└─ usr/                     # 系统级文件目录（安装时完整复制到系统 /usr/ 目录，对应 Linux 标准路径）  
   ├─ local/  
   │  └─ bin/               # 可执行文件目录（对应 Makefile 中 SYSTEM_BIN_DIR，存放主程序和库文件）  
   │  │  ├─ oim             # 主程序（从 ./oim.sh 复制并改名，Makefile 中 MAIN_PROG_TARGET，权限 755）  
   │  │  └─ functions       # 库函数文件（从 ./functions 复制，Makefile 中 LIB_FILE_SRC，权限 755）  
   │  └─ etc/
   │     └─ oim/
   │        └─ oim.config
   └─ share/                # 共享资源目录（存放桌面文件、图标等非执行资源）  
      ├─ applications/      # 桌面启动文件目录（对应 Makefile 中 SYSTEM_DESKTOP_DIR）  
      │  └─ oim.desktop     # 桌面文件（从 ./oim.desktop 复制，Makefile 中 DESKTOP_SRC，权限 644）  
      └─ icons/  
         └─ hicolor/        # 系统默认图标主题目录（对应 Makefile 中 SYSTEM_ICON_ROOT）  
            ├─ 16x16/  
            │  └─ apps/  
            │     └─ office-item-management.png  # 16x16 尺寸图标（从 ./src/icons 匹配尺寸文件复制，权限 644）  
            ├─ 32x32/  
            │  └─ apps/  
            │     └─ office-item-management.png  # 32x32 尺寸图标（同上）  
            ├─ 48x48/  
            │  └─ apps/  
            │     └─ office-item-management.png  # 48x48 尺寸图标（同上）  
            ├─ 64x64/  
            │  └─ apps/  
            │     └─ office-item-management.png  # 64x64 尺寸图标（同上）  
            ├─ 96x96/  
            │  └─ apps/  
            │     └─ office-item-management.png  # 96x96 尺寸图标（同上）  
            ├─ 128x128/  
            │  └─ apps/  
            │     └─ office-item-management.png  # 128x128 尺寸图标（同上）  
            ├─ 256x256/  
            │  └─ apps/  
            │     └─ office-item-management.png  # 256x256 尺寸图标（同上）  
            └─ 512x512/  
               └─ apps/  
                  └─ office-item-management.png  # 512x512 尺寸图标（同上，Makefile 中 ICON_SIZES 定义所有尺寸）  
## 计划表
- [x] 由make自动生成control，自动关联package、version
- [x] 由make自动生成postinst，自动关联目标程序名称、目标库名称、目标桌面文件名称、目标图标名称
- [x] 由make自动生成postrm，自动关联图标尺寸、目标图标名称、目标库名称、目标桌面文件名称
- [x] 出入库时间记录可选择
- [x] 插入记录文件的条目按时间顺序排序
- [x] 退出程序时自动备份，可回撤此次打开程序以来的操作，回撤按钮添加到主界面
- [x] 查询操作中添加查询所有记录的操作
- [x] 添加打印功能
- [x] 按时间查询的操作应该是时间段而非时间点
- [x] 调整主界面，添加查看当前库存。
- [x] 导出导入数据文件，tar.gz
- [x] 添加浏览职工名单，并可直接在此界面添加/删除职工
- [x] 完成主菜单和二级菜单，主菜单包含人员管理、库存管理、操作记录查询、存档数据管理、回撤本次运行期间所有操作以及退出
- [x] 完成情况所有存档数据的功能
