---
title: KConfig 使用文档
---

# 资料

## 参考文档

https://www.cnblogs.com/fluidog/p/15176680.html

https://pypi.org/project/kconfiglib/#installation-with-pip

https://www.kernel.org/doc/html/latest/kbuild/kconfig-language.html

## 示例代码

https://github.com/viys/kconfig

# 环境配置

## Windows

### 依赖

- cmake
- make
- MinGW
- python

```powershell
# 安装号 python 后用下面命令安装 kconfiglib 工具链
python -m pip install windows-curses
python -m pip install kconfiglib
```

### Cmake 构建

```powershell
# 在 CMakeLists.txt 目录下执行下面命令
mkdir build
cd .\build\
cmake -G "MinGW Makefiles" ..
```

### 打开 Kconfig

```powershell
# 开启 CMakeLists.txt 文件中的 CMAKE_HOST_WIN32 menuconfig 注释可以切换 menuconfig 工具
# kconfiglib 的 menuconfig.exe 比较容易有残影
# mconf-idf.exe 有乱码，切换为 utf-8 编码后并使用英文菜单可以减少乱码带来的问题缺失
# 在 build 目录下执行下面命令,即可对工程进行配置
make menuconfig
```

### 编译

```powershell
# 在 build 目录下执行下面命令,即可对工程进行编译
make
```

## Linux

### 依赖

- cmake
- make
- gxx
- python

```shell
# 更新 apt
sudo apt update
sudo apt upgrade
# 安装工具包
sudo apt install python3-kconfiglib
sudo apt-get install libncurses-dev kconfig-frontends
```

### 修改 CMakeListsxtxt

将 python 修改为自己系统上已有的 python 版本,如 python3  (可以直接略过此步,本工程已更新中 CmakeLists.txt 在不同系统中做了预处理)

### Cmake 构建

```shell
# 在 CMakeLists.txt 目录下执行下面命令
mkdir build
cd build/
cmake ..
```

### 打开 Kconfig

```shell
# 在 build 目录下执行下面命令,即可对工程进行配置
make menuconfig
```

### 编译

```powershell
# 在 build 目录下执行下面命令,即可对工程进行编译
make
```

# 管理脚本

后期可以根据自己的系统使用脚本来实现项目的管理.

# 高级用法

Kconfig 的高级用法见仓库 https://github.com/viys/oopc_cmake_stu advanced 分支