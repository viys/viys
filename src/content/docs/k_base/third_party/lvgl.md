---
title: Lvgl 9.3
---

# Lvgl 9.3 学习笔记

## 参考连接

[GitHub - lvgl/lv_port_pc_vscode](https://github.com/lvgl/lv_port_pc_vscode.git)

[GitHub - lvgl/lvgl: Embedded graphics library to create beautiful UIs for any MCU, MPU and display t](https://github.com/lvgl/lvgl.git)

[LVGL — Light and Versatile Embedded Graphics Library](https://lvgl.io/)

[欢迎阅读LVGL中文开发手册! — LVGL 文档](https://lvgl.100ask.net/master/index.html)

## 环境搭建

### Linux 环境搭建

```shell
git clone --recursive https://github.com/lvgl/lv_port_pc_vscode
sudo apt-get update && sudo apt-get install -y build-essential libsdl2-dev cmake
mkdir build
cd build
cmake ..
make -j
../bin/main
```

![img](assets/lvgl_1.png)