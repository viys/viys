---
title: OpenOCD 使用方法
---

在 Ubuntu 上使用 **PWLink2**（PWLINK2，一种类似 ST-Link 的调试器）连接 STM32 进行烧录和调试，可以按照以下步骤操作：

## **1. 安装驱动和工具**

PWLink2 通常兼容 **OpenOCD** 或 **pyOCD**，推荐使用 OpenOCD 进行调试和烧录。

### **(1) 安装 OpenOCD**

```bash
sudo apt update
sudo apt install openocd
```

### **(2) 检查设备是否识别**

插入 PWLink2 后，运行：

```bash
lsusb
```

如果看到类似 `**1e0a:8007**`（PowerWriter 设备）或 `**0483:3748**`（ST-Link 兼容模式），说明设备已识别。

## **2. 配置 OpenOCD**

PWLink2 可能需要自定义 OpenOCD 配置。创建一个配置文件，例如 `pwlink2.cfg`：

```bash
nano pwlink2.cfg
```

写入以下内容（适用于 STM32）：

```txt
# PWLink2 配置（类似 ST-Link）
source [find interface/pwlink2.cfg]
transport select hla_swd

# STM32 目标芯片配置（例如 STM32F103）
source [find target/stm32f1x.cfg]

# 复位配置
reset_config srst_only
```

> **注**：如果 OpenOCD 没有 `pwlink2.cfg`，可以尝试 `interface/stlink.cfg`（如果 PWLink2 工作在 ST-Link 兼容模式）。

## **3. 连接 STM32 并烧录**

### **(1) 启动 OpenOCD**

```bash
openocd -f pwlink2.cfg
```

如果成功，会显示：

```txt
Info : PWLink2 (VID:PID=1e0a:8007) firmware: V1.0
Info : STM32 flash size = 64 KiB
Info : clock speed = 1000 kHz
Info : STM32F1xx device detected
```

> **如果失败**：
>
> - 检查 USB 连接。
> - 尝试 `interface/stlink.cfg` 替代 `pwlink2.cfg`。

### **(2) 使用 GDB 调试**

```bash
arm-none-eabi-gdb firmware.elf
```

在 GDB 中连接：

```txt
(gdb) target extended-remote :3333
(gdb) load
(gdb) monitor reset halt
(gdb) continue
```

### **(3) 使用 Telnet 烧录**

```bash
telnet localhost 4444
```

在 Telnet 中运行：

```bash
> flash write_image erase firmware.bin 0x08000000
> reset
```

## **4. 直接烧录** **`.bin`** **文件**

如果不想用 OpenOCD，可以使用 `st-flash`（如果 PWLink2 兼容 ST-Link）：

```bash
st-flash write firmware.bin 0x08000000
```

## **5. 权限问题**

如果出现 `Permission denied`，添加 udev 规则：

```bash
sudo nano /etc/udev/rules.d/99-pwlink2.rules
```

写入：

```txt
# PWLink2
SUBSYSTEM=="usb", ATTR{idVendor}=="1e0a", ATTR{idProduct}=="8007", MODE="0666"
```

然后重新加载：

```bash
sudo udevadm control --reload
sudo udevadm trigger
```

## **6. 总结**

| **操作**     | **命令**                                          |
| ------------ | ------------------------------------------------- |
| 安装 OpenOCD | `sudo apt install openocd`                        |
| 检查设备     | `lsusb`                                           |
| 启动 OpenOCD | `openocd -f pwlink2.cfg`                          |
| GDB 调试     | `target extended-remote :3333`                    |
| Telnet 烧录  | `flash write_image erase firmware.bin 0x08000000` |
| 直接烧录     | `st-flash write firmware.bin 0x08000000`          |

## **7. 可能遇到的问题**

### **Q1: PWLink2 无法识别**

- 检查 USB 线是否正常。
- 尝试 `dmesg | grep usb` 查看内核日志。

### **Q2: OpenOCD 报错** **`No device found`**

- 确保 PWLink2 工作在 **ST-Link 模式**（部分设备需切换模式）。
- 尝试 `interface/stlink.cfg` 替代 `pwlink2.cfg`。

### **Q3: 烧录失败**

- 检查 STM32 的 **Boot0** 引脚是否接对（通常 Boot0=0 运行模式，Boot0=1 烧录模式）。
- 确保供电稳定。

现在你应该可以在 Ubuntu 上使用 **PWLink2** 连接 STM32 进行开发和调试了！ 🚀  

如果有问题，请提供具体错误信息以便进一步排查。