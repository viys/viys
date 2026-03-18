---
title: BLE 抓包数据解析
---

# BLE 抓包数据解析

> 记录使用 Wireshark + nRF Sniffer 抓取的 BLE 数据包，逐包解析字段含义。

---

## BLE 数据包格式概览

BLE 数据包分为 4 层，从外到内依次嵌套：

```
[Physical] Preamble | Access Address | [LL PDU] | CRC
                                          ↓
                              [LL] LL Header | [L2CAP PDU] | MIC
                                                    ↓
                                    [L2CAP] Length | CID | [ATT PDU]
                                                               ↓
                                           [ATT] OpCode | Handle | Value
```

| 层 | 字段 | 大小 | 说明 |
|----|------|------|------|
| Physical | Preamble | 1B | 前导码，无线同步用，nRF Sniffer **不捕获** |
| Physical | Access Address | 4B | 广播固定 `0x8E89BED6`，连接后协商 |
| Physical | CRC | 3B | 循环冗余校验 |
| LL | LL Header | 2B | PDU 类型、地址类型、长度 |
| LL | MIC | 4B | 消息完整性校验（加密时存在） |
| L2CAP | Header | 4B | Length(2B) + CID(2B) |
| ATT | Header | 3B | OP Code(1B) + Attribute Handle(2B) |
| ATT | Payload | max 244B | 实际交互数据 |

> **注意**：nRF Sniffer 会在每个数据包前添加 **17 字节私有头部**（含 RSSI、信道等元数据），不属于 BLE 协议内容。

---

## 数据包记录

---

### Frame 253 — ADV_IND 广播包

**文件**：`ble_connect.pcapng`
**类型**：BLE 广播包（设备主动广播，等待主机连接）
**设备**：`ckc_100297fd61`（MAC: `d0:27:04:a6:ba:94`）

#### 原始字节

```
0000  17 2c 00 03 97 70 02 0a  01 25 25 00 00 49 62 56
0010  1d d6 be 89 8e 00 19 94  ba a6 04 27 d0 02 01 06
0020  0f 09 63 6b 63 5f 31 30  30 32 39 37 66 64 36 31
0030  4e 3b 0a
```

#### 字节划分

```
0x00 ~ 0x10  (17B)  nRF Sniffer 私有头部（RSSI、信道等元数据）
0x11 ~ 0x14  (4B)   Access Address:  d6 be 89 8e → 0x8E89BED6（小端序）
0x15         (1B)   LL Header 字节0: 00
0x16         (1B)   LL Header 字节1: 19 (Length = 25)
0x17 ~ 0x1c  (6B)   AdvA:            94 ba a6 04 27 d0 → d0:27:04:a6:ba:94（小端序）
0x1d ~ 0x1f  (3B)   AD: Flags        02 01 06
0x20 ~ 0x2f  (16B)  AD: Device Name  0f 09 "ckc_100297fd61"
0x30 ~ 0x32  (3B)   CRC:             4e 3b 0a
```

#### LL Header 解析（`00 19`）

| 字段 | 原始值 | 含义 |
|------|--------|------|
| PDU Type | `0000b` | ADV_IND，可连接无向广播 |
| ChSel | `1` | 支持 Channel Selection Algorithm #1 |
| TxAdd | `0` | 广播地址类型 = Public（固定地址） |
| Length | `0x19 = 25` | PDU 负载长度 25 字节 |

#### Advertising Data 解析

AD 结构统一格式：`Length(1B) | Type(1B) | Value`

**AD 1 — Flags（`02 01 06`）**

```
02  → Length = 2
01  → Type = Flags
06  → Value = 0b00000110
         bit1 = 1 → LE General Discoverable Mode（通用可发现）
         bit2 = 1 → BR/EDR Not Supported（纯 BLE 设备）
```

**AD 2 — Device Name（`0f 09 63 6b 63 5f 31 30 30 32 39 37 66 64 36 31`）**

```
0f  → Length = 15
09  → Type = Complete Local Name
63 6b 63 5f 31 30 30 32 39 37 66 64 36 31
↓ ASCII
"ckc_100297fd61"
```

#### 总结

设备 `d0:27:04:a6:ba:94`（名叫 `ckc_100297fd61`）正在广播，声明自己是**纯 BLE 设备**，处于**通用可发现模式**，等待主机扫描并发起连接。

---

### Frame 254 — SCAN_REQ 扫描请求包

**文件**：`ble_connect.pcapng`
**类型**：主动扫描请求（主机向设备索要更多广播数据）
**扫描方**：`70:7b:26:16:e7:32`（Random 地址，隐私保护）
**被扫描方**：`d0:27:04:a6:ba:94`（Public 地址，即上一包的广播设备）

#### 原始字节

```
0000  17 1f 00 03 98 70 02 0a  01 25 2b 00 00 f7 63 56
0010  1d d6 be 89 8e 43 0c 32  e7 16 26 7b 70 94 ba a6
0020  04 27 d0 53 26 dd
```

#### 字节划分

```
0x00 ~ 0x10  (17B)  nRF Sniffer 私有头部
0x11 ~ 0x14  (4B)   Access Address:  d6 be 89 8e → 0x8E89BED6（广播固定值）
0x15         (1B)   LL Header 字节0: 43
0x16         (1B)   LL Header 字节1: 0c (Length = 12)
0x17 ~ 0x1c  (6B)   ScanA:           32 e7 16 26 7b 70 → 70:7b:26:16:e7:32（小端序）
0x1d ~ 0x22  (6B)   AdvA:            94 ba a6 04 27 d0 → d0:27:04:a6:ba:94（小端序）
0x23 ~ 0x25  (3B)   CRC:             53 26 dd
```

#### LL Header 解析（`43 0c`）

`43` = `0b01000011`，逐位解析：

| 字段 | 位 | 原始值 | 含义 |
|------|----|--------|------|
| PDU Type | [3:0] | `0011b` = 0x3 | **SCAN_REQ**，主动扫描请求 |
| Reserved | [4] | `0` | 保留 |
| Reserved | [5] | `0` | 保留 |
| TxAdd | [6] | `1` | 扫描方地址类型 = **Random**（隐私地址） |
| RxAdd | [7] | `0` | 被扫描方地址类型 = **Public** |
| Length | — | `0x0c = 12` | ScanA(6B) + AdvA(6B) = 12 ✓ |

#### SCAN_REQ 与 SCAN_RSP 的关系

```
设备广播 (ADV_IND)
    ↓  主机发现广播，想要获取更多信息
主机发送 SCAN_REQ  ← 当前这包
    ↓
设备回复 SCAN_RSP（携带额外广播数据）
```

> SCAN_REQ 只在**主动扫描模式**下产生，被动扫描不发此包。
> 扫描方使用 Random 地址（`70:7b:26:16:e7:32`）是 BLE 隐私保护机制，防止被追踪。

#### 总结

主机（`70:7b:26:16:e7:32`）收到 Frame 253 的广播后，用随机地址向设备（`d0:27:04:a6:ba:94`）发送 SCAN_REQ，请求设备回复 SCAN_RSP 以获取更完整的广播信息。

---

<!-- 后续包分析追加在此处 -->
