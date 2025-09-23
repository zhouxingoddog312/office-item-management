# 用于办公室用品管理
### 安装后目录
├── DEBIAN/
│   ├── control
│   ├── postinst  # 安装后执行的脚本
│   └── ...
└── usr/
    ├── share/
    │   └── office-item-management/  # 临时存放需要处理的文件
    │       ├── icons/
    │       │   ├── 16x16.png
    │       │   ├── 32x32.png
    │       │   └── ...
    │       └── oim.desktop  # .desktop源文件
    └── local/
        └── bin/
            ├── oim  # 应用主程序
            └── functions
