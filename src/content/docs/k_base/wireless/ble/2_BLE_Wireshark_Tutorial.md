---
title: BLE Wireshark 抓包
---

# BLE 抓包完全教程：nRF52840 Dongle + Wireshark

> 基于 nRF Sniffer for Bluetooth LE v4.1.1 + nrfutil v7 + Wireshark
> 适用于 Windows 10/11（全新环境从零开始）

---

## 一、前置软件安装

### 1.1 安装 Wireshark

从官网下载并安装 Wireshark（v3.4.1 或更高稳定版）：

> https://www.wireshark.org/download.html

安装时保持默认选项即可。

### 1.2 获取 nrfutil

从 Nordic 官网下载 nrfutil 可执行文件：

> https://www.nordicsemi.com/Products/Development-tools/nRF-Util

下载后将 `nrfutil.exe` 放到一个固定目录，例如 `D:\tools\nrfutil.exe`，
或将其所在目录加入系统 PATH 环境变量（方便全局调用）。

### 1.3 安装 nrfutil 所需插件

打开命令行，进入 `nrfutil.exe` 所在目录，执行：

```bash
# 安装 ble-sniffer 插件
nrfutil.exe install ble-sniffer

# 安装 device 插件（用于列出设备和烧录固件）
nrfutil.exe install device
```

> **无需安装 Python**，新版 nrfutil 的 Wireshark 插件是原生可执行文件，不依赖 Python。

---

## 二、初始化配置（首次使用执行一次）

### 2.1 Bootstrap

```bash
nrfutil.exe ble-sniffer bootstrap
```

此命令自动完成两件事：
- 下载 sniffer 固件到 `%USERPROFILE%\.nrfutil\share\nrfutil-ble-sniffer\firmware\`
- 在 Wireshark 的 Personal Extcap 目录安装以下文件：
  - `nrfutil-ble-sniffer-shim.exe`
  - `nrfutil-ble-sniffer-hci-shim.exe`
  - `nrfutil-ble-sniffer-shim-config.json`

---

## 三、烧录 Dongle 固件

### 3.1 插入 Dongle，查看序列号

将 nRF52840 Dongle 插入电脑，执行：

```bash
nrfutil.exe device list
```

找到 Traits 包含 `nordicDfu` 的设备，记录其序列号，例如：

```
C55ED95B17E7
Product         nRF52 Connectivity
Ports           COM22
Traits          nordicDfu, nordicUsb, serialPorts, usb
```

> 序列号即第一行的字符串（`C55ED95B17E7`），每个 Dongle 不同。

### 3.2 烧录 Sniffer 固件

将 `<序列号>` 替换为上一步查到的实际值：

```bash
nrfutil.exe device program \
  --firmware "%USERPROFILE%\.nrfutil\share\nrfutil-ble-sniffer\firmware\sniffer_nrf52840dongle_nrf52840_4.1.1.zip" \
  --serial-number <序列号>
```

烧录成功后，Dongle 会重新枚举 USB，再次执行 `device list` 确认：

```
Product         nRF Sniffer for Bluetooth LE
Traits          nordicUsb, serialPorts, usb
```

> **注意：** 烧录后 COM 端口号可能改变，以新端口为准。
>
> **一次烧录，永久有效**：固件保存在 Dongle 中，换电脑使用时不需要重新烧录，
> 只需在新电脑上重新执行第一、二章的软件安装步骤。

---

## 四、配置 Wireshark

### 4.1 刷新接口

打开 Wireshark，按 **F5** 或点击 **Capture > Refresh Interfaces**。

主页接口列表中应出现：`nRF Sniffer for Bluetooth LE COMxx`

若未出现，检查 extcap 目录（**Help > About Wireshark > Folders > Personal Extcap path**）
中是否存在 `nrfutil-ble-sniffer-shim.exe`，若没有，重新执行 `bootstrap`。

### 4.2 启用 nRF Sniffer 工具栏

**View > Interface Toolbars > nRF Sniffer for Bluetooth LE**

工具栏字段说明：

| 字段 | 说明 |
|------|------|
| Interface | 选择 Dongle 对应的 COM 口 |
| Device | 设备列表（默认 All advertising devices） |
| Key | 加密密钥类型（用于解密加密连接） |
| Value | 密钥值 |
| Adv Hop | 广播信道跳频顺序（默认 37,38,39） |

---

## 五、开始抓包

### 5.1 抓所有附近设备广播

1. 双击 `nRF Sniffer for Bluetooth LE COMxx` 接口开始捕获
2. 工具栏 Device 下拉保持 **All advertising devices**
3. 附近所有 BLE 设备广播包实时显示

### 5.2 跟踪单个设备连接

1. 启动抓包，等待目标设备出现在 Device 下拉列表
2. 从列表中选择目标设备（显示名称或 MAC 地址）
3. 用 Central 设备（手机等）连接该 Peripheral
4. Wireshark 捕获完整连接过程（广播 → 连接建立 → 数据交互）

### 5.3 RSSI 过滤（减少附近无关设备干扰）

在 Capture Filter 栏输入（只抓信号 >= -70dBm 的包）：

```
rssi >= -70
```

---

## 六、抓取加密连接

### 6.1 Legacy Just Works 配对

无需任何额外操作，sniffer 自动解密。

### 6.2 Legacy Passkey 配对

1. 工具栏 Key 下拉选择 **Legacy Passkey**
2. Value 框输入 6 位 Passkey，按 **Enter**
3. 在配对设备上输入相同 Passkey 完成配对

### 6.3 已绑定设备（提供现有 LTK）

1. Key 下拉选择 **Legacy LTK** 或 **SC LTK**（取决于绑定类型）
2. Value 框输入 LTK（十六进制，`0x` 开头，大端序）
3. 按 **Enter**，然后触发两设备建立加密连接

### 6.4 LE Secure Connections（非 debug 模式）

1. Key 下拉选择 **SC Private Key**
2. 输入 32 字节 Diffie-Hellman 私钥（`0x` 开头，大端序）
3. 按 **Enter**，然后发起配对

---

## 七、按 MAC 地址过滤

### 7.1 筛选指定设备的所有广播包

```
btle.advertising_address == aa:bb:cc:dd:ee:ff
```

> MAC 地址不区分大小写，`AA:BB:CC:DD:EE:FF` 和 `aa:bb:cc:dd:ee:ff` 等价。

### 7.2 同时筛选多个 MAC 地址

```
btle.advertising_address == aa:bb:cc:dd:ee:ff || btle.advertising_address == 11:22:33:44:55:66
```

### 7.3 排除某个 MAC 地址

```
btle.advertising_address && btle.advertising_address != aa:bb:cc:dd:ee:ff
```

### 7.4 只看广播包 + 排除空数据包

```
btle.advertising_address == aa:bb:cc:dd:ee:ff && btle.length != 0
```

---

## 八、按蓝牙名称过滤

BLE 设备名称字段因 Wireshark 版本和抓包插件不同，字段名有差异：

| 环境 | 字段名 | 说明 |
|------|--------|------|
| 标准 Wireshark | `btcommon.eir_ad.entry.local_name` | 通用字段 |
| nRF Sniffer 插件 | `btcommon.eir_ad.entry.device_name` | 实测有效 |

> 不确定用哪个时，展开包详情找到设备名字段，**右键 → Apply as Filter**，让 Wireshark 自动生成正确字段名。

### 8.1 精确匹配名称

```
btcommon.eir_ad.entry.device_name == "ckc_1002a5b623"
```

```
btcommon.eir_ad.entry.local_name == "MyDevice"
```

### 8.2 包含某段字符串（模糊匹配）

```
btcommon.eir_ad.entry.device_name contains "ckc_"
```

> `contains` 区分大小写。

### 8.3 不区分大小写的模糊匹配

```
btcommon.eir_ad.entry.device_name matches "(?i)ckc_"
```

> `matches` 使用正则表达式，`(?i)` 表示忽略大小写。

### 8.4 正则匹配以某前缀开头的名称

```
btcommon.eir_ad.entry.device_name matches "^ckc_"
```

### 8.5 原始字节匹配（通用兜底方案）

当以上字段均报错时，直接搜索数据帧中的原始内容：

```
frame contains "ckc_1002a5b623"
```

- 不依赖解析器层级，任何版本和插件均可用
- 区分大小写
- 缺点：可能误匹配非名称字段中的同名字节序列

结合 MAC 缩小范围：

```
frame contains "ckc_" && btle.advertising_address
```

---

## 九、组合过滤

### 9.1 MAC 地址 OR 名称（二选一命中即显示）

```
btle.advertising_address == aa:bb:cc:dd:ee:ff || btcommon.eir_ad.entry.device_name contains "ckc_"
```

### 9.2 只显示有名称的广播包（过滤匿名设备）

```
btcommon.eir_ad.entry.device_name
```

> 单独写字段名表示"该字段存在"，等价于该字段不为空。

---

## 十、界面操作技巧

### 10.1 输入过滤器

在顶部过滤栏输入表达式，按回车或点击右侧箭头应用：

- 输入时变**绿色** = 语法正确
- 变**红色** = 语法错误（常见原因：使用了中文引号 `""` 而非英文引号 `""`）

### 10.2 保存常用过滤器

点击过滤栏右侧的**书签图标** → **Save this filter**，填写名称后保存，下次可直接从下拉列表选用。

### 10.3 从包详情直接生成过滤器

不用手写过滤器，可以直接从包内容点击生成：

1. 在包列表点击一个广播包
2. 展开包详情：**Bluetooth Low Energy Link Layer > Advertising Data > Entry**
3. 右键点击 `Device Name` 或 `LE Bluetooth Device Address` 的值
4. 选择 **Apply as Filter > Selected**（或 `Prepare as Filter` 先预览）

Wireshark 会自动填入正确的过滤表达式。

### 10.4 过滤器表达式向导

菜单 **Analyze → Display Filter Expression**：

- 搜索 `btcommon` 可列出所有蓝牙相关字段
- 可视化选择字段、操作符和值，适合不熟悉字段名时使用

### 10.5 把 MAC / 名称设为列（方便一览）

默认列表不显示 MAC 地址和设备名，可以添加为列：

1. 点击任意一个广播包
2. 展开详情找到 `Advertising Address` 或 `Device Name`
3. **右键 > Apply as Column**

之后列表里会直接显示每条广播包对应的 MAC 和名称，无需逐条展开查看。

---

## 十一、命令行抓包（不用 Wireshark GUI）

```bash
nrfutil.exe ble-sniffer sniff --port COMxx --output capture.pcap
```

输出 pcap 文件，可用 Wireshark 离线分析，也可配合 tshark 实时过滤：

```bash
tshark -r capture.pcap -Y 'btcommon.eir_ad.entry.device_name contains "ckc_"'
```

---

## 十二、故障排除

| 问题 | 解决方法 |
|------|---------|
| Wireshark 中看不到 nRF Sniffer 接口 | 按 F5 刷新；重新执行 `ble-sniffer bootstrap` |
| COM 端口 >= COM200 | 设备管理器 > 端口 > 属性 > 高级，改为 <200 的端口号 |
| 没有收到任何包 | 重新插拔 Dongle；执行 `device list` 确认固件已烧录 |
| 包显示异常 | Analyze > Enabled Protocols 确认 NORDIC_BLE 已启用 |
| 工具栏不显示 | View > Interface Toolbars > nRF Sniffer for Bluetooth LE |
| 过滤栏变红（字段不存在） | nRF Sniffer 环境改用 `device_name` 或 `frame contains` |
| 过滤栏变红（语法错误） | 检查是否使用了中文引号，改为英文引号 `""` |

---

## 十三、常用过滤器速查表

| 目的 | 过滤器 |
|------|--------|
| 所有 BLE 包 | `btle` |
| 只看广播包 | `btle.advertising_address` |
| 指定 MAC | `btle.advertising_address == aa:bb:cc:dd:ee:ff` |
| 排除指定 MAC | `btle.advertising_address != aa:bb:cc:dd:ee:ff` |
| 隐藏空数据包 | `btle.length != 0` |
| 名称精确匹配（nRF Sniffer） | `btcommon.eir_ad.entry.device_name == "ckc_1002a5b623"` |
| 名称精确匹配（标准） | `btcommon.eir_ad.entry.local_name == "MyDevice"` |
| 名称包含字符串 | `btcommon.eir_ad.entry.device_name contains "ckc_"` |
| 名称正则（忽略大小写） | `btcommon.eir_ad.entry.device_name matches "(?i)ckc_"` |
| 只显示有名称的设备 | `btcommon.eir_ad.entry.device_name` |
| 名称原始字节匹配（通用兜底） | `frame contains "ckc_1002a5b623"` |
| 仅数据信道包（连接数据） | `nordic_ble.channel < 37` |
| ATT 属性协议包 | `btatt` |
| SMP 安全配对包 | `btsmp` |

---

## 十四、路径速查

```
固件目录:    %USERPROFILE%\.nrfutil\share\nrfutil-ble-sniffer\firmware\
Extcap 目录: %APPDATA%\Roaming\Wireshark\extcap\
```
