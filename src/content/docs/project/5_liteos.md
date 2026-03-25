---
title: LiteOS
description: 一个基于 C 语言与 CMake 的轻量级 OS 示例工程，包含事件、软件定时器与协作式任务调度。
---

# LiteOS

`LiteOS` 是一个基于 C 语言实现的轻量级 OS 示例工程，使用 CMake 组织构建。当前项目围绕三个核心能力展开：

- 事件系统：支持事件注册、投递与派发
- 软件定时器：支持单次和循环定时回调
- 协作式任务调度：支持按周期与优先级执行任务

项目地址：[LiteOS](https://github.com/viys/LiteOS)

## 项目特点

- `os_init()` 统一初始化事件、定时器和任务子系统
- `os_run(timestamp)` 作为主循环入口，驱动整个调度流程
- 支持外部传入时间戳，便于适配 PC 模拟或 MCU 硬件定时器
- 模块划分清晰，适合作为裸机框架、轻量级调度内核或教学示例工程继续扩展

## 目录结构

```text
LiteOS/
├── CMakeLists.txt
├── build.ps1
├── project/
│   ├── app/
│   │   └── main.c
│   └── os/
│       ├── os.h / os.c
│       ├── os_config.h
│       ├── os_type.h
│       ├── event.h / event.c
│       ├── timer.h / timer.c
│       └── task.h / task.c
├── build/
├── release/
└── scripts/
```

## 核心运行流程

LiteOS 的主循环非常简单：

```c
os_init();

while (1) {
    os_run(get_timestamp());
}
```

`os_run()` 当前按如下顺序执行：

1. 更新系统 tick
2. 检查并执行到期定时器
3. 运行到期任务
4. 派发事件队列中的全部事件

这种设计非常适合裸机、轮询式循环或桌面模拟环境。

## 示例内容

示例入口 `project/app/main.c` 展示了 LiteOS 的典型使用方式：

- 创建两个循环定时器：`500ms` 与 `1s`
- 创建两个周期任务，分别用于 `500ms` 模拟 LED 翻转与 `2000ms` 打印系统 tick
- 注册并投递一个按键事件 `EVT_KEY`
- 在 `while (1)` 中持续调用 `os_run(GetTickCount())`

示例主循环如下：

```c
while (1) {
    os_run(GetTickCount());
    Sleep(1);
}
```

## 配置说明

核心容量参数位于 `project/os/os_config.h`：

```c
#define OS_EVT_QUEUE_SIZE   32
#define OS_EVT_HANDLER_MAX  32
#define OS_TIMER_MAX        16
#define OS_USE_TASK         1
```

当 `OS_USE_TASK` 为 `1` 时，会额外启用任务调度模块：

```c
#define OS_TASK_MAX         8
```

如果你只想保留“事件 + 定时器”能力，可以将 `OS_USE_TASK` 改为 `0`。

## 构建方法

### Windows

依赖工具：

- CMake 3.15+
- Ninja

常用命令：

```powershell
.\build.ps1 all
.\build.ps1 cmake
.\build.ps1 make
.\build.ps1 clean
.\build.ps1 delete
```

也可以直接使用 CMake：

```powershell
cmake -S . -B build -G Ninja
cmake --build build
```

## 适用场景

- 作为轻量级嵌入式调度内核的起点
- 用于事件系统、软件定时器和任务调度的教学演示
- 作为后续扩展消息机制、延时任务或更复杂优先级策略的实验工程

## 许可证

MIT License
