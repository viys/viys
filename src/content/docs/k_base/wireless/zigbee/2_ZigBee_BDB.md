---
title: ZigBee BDB
---
# **ZigBee 基础行为规范**

为了规范基础设备的环境、初始化、commissioning 和操作过程，以确保配置文件的互操作性。

**Scope 规范范围**

- The **environment** required for the base device（基础设备所需环境）

  对应 BDB 文档第五章 Environment variables。

  指 ZigBee 基础设备实现标准化行为所依赖的 “底层参数与逻辑框架”，并非物理环境，而是协议层面的 “运行基础”，确保设备在统一规则下交互。

- The **initialization** procedures of the base device（基础设备的初始化流程）

  对应 BDB 文档第七章 Initialization。

  指 ZigBee 设备上电的启动流程，核心是恢复持久化数据到判定网络状态再到执行对应操作，确保设备从断电状态平稳过渡到可运行状态。

- The **commissioning** procedures of the base device（基础设备的调试流程）

  对应 BDB 文档第八章 Commissioning。

  是 ZigBee 设备从未入网或未绑定到可正常联动的核心操作集合，规范定义了 4 类标准化调试机制，覆盖组网、功能绑定、近距离配置等场景，是设备实现互操作的关键。

- The **reset** procedures of the base device（基础设备的复位流程）

  对应 BDB 文档第九章 Reset。

  指将设备恢复到特定状态的操作，规范定义了 5 类复位机制，对应不同复位强度从仅重置属性到清除所有网络数据，满足不同运维需求，如故障排查和设备迁移等。

- The **security** procedures of the base device（基础设备的安全流程）

对应 BDB 文档第十章 Security。

指 ZigBee 设备在入网、数据传输、密钥管理过程中的安全机制，规范通过密钥体系、链路密钥交换、信任中心管理三大模块，确保网络数据不被窃取、设备不被非法接入

**Conformance levels 一致性等级**

- **SHALL                      必须遵守**
- **SHALL NOT             禁止遵守**
- **SHOULD                  应当遵守**
- **SHOULD NOT         不应当遵守**
- **RECOMMENDED    推荐遵守**
- **MAY                          应当遵守**
## **Definitions 定义**

Node 是整台设备，Device 是功能集，Endpoint 是功能入口

| **定义名称**                 | **中文名称**   | **定义解释**                                                 |
| ---------------------------- | -------------- | ------------------------------------------------------------ |
| Application cluster          | 应用集群       | 是设备功能的基本构建块，它包括一组相关属性以及一组与属性交互的命令，用于实现设备的特定功能。 |
| Application transaction      | 应用事务       | 是由集群命令（可能包括响应）组成的，用于执行设备的持久功能，如属性报告或致动命令。 |
| Bind or binding(verb)        | 绑定           | 是 ZigBee 实现设备间定向通信的核心机制，本质是在两个或多个设备的特定功能集群间，预先建立一条固定的通信链路。 |
| Binding(noun)                | 绑定           | 是 ZigBee 网络中，预先存储在设备内的 “功能 - 目标” 关联记录，是客户端设备快速找到服务器设备的 “通信导航表”。 |
| Centralized security network | 集中式安全网络 | 集中式安全网络是由具有信任中心功能的 ZigBee 协调器形成的 ZigBee 网络。加入此类网络的每个节点都可以通过信任中心进行身份验证，然后才能在网络上操作。 |
| Commissioning director       | 协调主管       | 网络中的一个节点，能够直接编辑网络中任何节点上的绑定和报告配置。 |
| Device                       | 设备           | 不是指物理硬件本身，而是运行在节点某个端点上、对应特定功能类型的应用实现，一个物理节点可通过多个端点承载多个 Device。 |
| Distributed security network | 分布式安全网络 | 是由 ZigBee 路由器形成的 ZigBee 网络，其没有信任中心。加入此类网络的每个节点先由其父节点进行身份验证，然后才可以在网络上操作。 |
| Dynamic device               | 动态设备       | 是一种运行在节点端点上、没有固定应用集群集合的应用实现，其功能可灵活配置，而非遵循预设的标准设备类型。 |
| EZ-Mode                      | 简单模式       | 是一种简化的设备调试（Commissioning）方法，通过标准化流程自动完成网络接入（Network Steering）和功能绑定（Finding & Binding），无需用户手动配置地址或集群。 |
| EZ-Mode finding & binding    | 查找和绑定     | 是 EZ-Mode 的核心子功能，通过自动化流程，让用户无需手动配置即可实现功能关联。 |
| EZ-Mode network steering     | 网络转向       | 是 EZ-Mode 的核心子功能，是 Zigbee 设备快速组网的关键机制。通过标准化的自动流程，让 Zigbee 设备无须手动配置网络参数，即可完成入网或开放网络让其他的设备入网。 |
| Initiator cluster            | 发起者集群     | 是应用集群的子类，是应用事务的发起方，即向其它设备的目标集群发送命令。 |
| Joined                       | 已加入         | 描述节点网络状态，特指节点成功完成网络加入流程或网络创建流程，但并不代表该节点与其他设备建立了绑定关系，仅仅代表节点完成网络接入的基础步骤。 |
| Node                         | 节点           | 在单个网络上的具有单个 IEEE 地址的 ZigBee-PRO 协议栈的单个实例，一个节点由多个逻辑设备（Device）实例组成。 |
| Simple device                | 简单设备       | 是依附于特定的端点，包含强制应用集群，遵循标准化设备类型的设备。不同厂商生产的同类型 Simple Device 可直接互联互通，无需额外适配。 |
| Target cluster               | 目标集群       | 是应用集群的子类，是应用事务的接收和响应方，即接收和响应其它设备的目标集群发送的命令。 |
| Touchlink commissioning      | 触摸链接调试   | 是 ZigBee 中一种基于近距离 Inter-PAN 通信的可选调试机制，让设备在物理近距离内无需手动配置网络参数，即可自动完成组网或设备关联。 |
| Utility cluster              | 实用集群       | 是 ZigBee 应用层中专门用于非持久性功能交互 的集群类型，核心职责是支撑设备的调试、配置、发现等辅助操作，而非实现设备的核心业务功能。 |
| Zigbee coordinator           | 协调器         | ZC 是 ZigBee 网络的核心发起者与管理者，属于 ZigBee 逻辑设备类型之一（节点描述符逻辑类型字段为 0b000），需集成信任中心功能。 |
| Zigbee router                | 路由器         | ZR 是兼具入网与管理局部节点的能力（节点描述符逻辑类型字段为 0b001），可加入集中式或分布式安全网络，也能在无现有网络时创建分布式安全网络。 |
| Zigbee end device            | 终端设备       | ZED 是仅能加入现有网络的轻量级节点（节点描述符逻辑类型字段为 0b010），无法主动创建网络。 |

## **相关缩写**

| **缩写** | **描述**             | **缩写** | **描述**               |
| -------- | -------------------- | -------- | ---------------------- |
| AES      | 高级加密标准         | MMO      | Matyas-Meyer-Oseas     |
| AIB      | 应用支持子层信息库   | NLME     | 网络层管理实体         |
| APS      | 应用支持子层         | NVRAM    | 非易失性随机存取存储器 |
| APSME    | 应用支持子层管理实体 | NWK      | 网络                   |
| CBKE     | 基于证书的密钥交换   | OTA      | Over the air           |
| CCITT    | 国际电信委员会       | PAN      | 个域网                 |
| CD       | commissioning 主管   | PHY      | 物理层                 |
| CRC      | 循环冗余校验         | TC       | 信任中心               |
| EP       | 端点                 | WPAN     | 无线个人区域网         |
| EUI      | 扩展唯一标识符       | ZC       | ZigBee 协调器          |
| ID       | 标识符               | ZCL      | ZigBee 集群库          |
| IEEE     | 电气和电子工程师协会 | ZDO      | ZigBee 设备对象        |
| LQI      | 链路质量指示         | ZED      | ZigBee 终端设备        |
| MAC      | 媒体访问控制         | ZR       | ZigBee 路由器          |

## Environment variables **环境变量**

指定实现符合基础设备行为规范的节点所需的常量和属性。规范中指定的所有常量都使用前缀 “bdbc”（基础设备行为常量），并且所有属性都使用前缀 “bdb”（基础设备行为）。

- Constant    常量
- Attributes    属性

## **General requirements 一般要求**

规定了所有实现基础设备行为规范的节点的一般要求。

详见 BDB 文档第六章 General requirements。

- ZigBee logical device types    ZigBee 逻辑设备
- Network securitymodels    网络安全模型
- Link keys    链路密钥
- Use of install codes    安装码的使用
- Commissioning    调试配置
- Minimum requirements for all devices    所有设备的最低要求
- Default reporting configuration    默认报告配置
- MAC data polling    MAC 层数据轮询
- ZigBee persistent data    ZigBee 持久化数据

## Initialization 初始化

详见 BDB 文档第七章 Initialization。

## Commissioning 调试配置

详见 BDB 文档第八章 Commissioning。

## **Reset 重启**

详见 BDB 文档第九章 Reset。

## **Security 安全**

详见 BDB 文档第十章 Security。

## **参考文档**

<embed src="/viys/docs/docs-13-0402-13-00zi-Base-Device-Behavior-Specification.pdf" type="application/pdf" width="100%" height="600px">

