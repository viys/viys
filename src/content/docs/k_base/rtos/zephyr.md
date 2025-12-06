---
title: Zephyr
---

# Zephyr 资料

https://docs.zephyrproject.org/latest/

# 环境配置

https://docs.zephyrproject.org/latest/develop/getting_started/index.html

# 工程构建

## 拉取代码

```shell
git clone https://github.com/viys/zephyr_create.git
```

## 安装依赖

```shell
cd zephyr_create/
source ~/zephyrproject/.venv/bin/activate
west init -l project/
west update
```

## 工程编译

```shell
west build -b qemu_x86 -p auto project/
```

## 工程运行（烧录）

### 工程运行

```shell
west -t run
```

### 工程烧录

```shell
west flash
```