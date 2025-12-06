---
title: Doxygen 使用文档
---

https://www.doxygen.nl/manual/starting.html

# 依赖

- Doxygen
- Graphviz

# Doxygen 注释规范（C语言版）

本文档定义了使用 Doxygen 为 C 语言项目编写注释的规范，适用于函数、结构体、宏、文件等各种实体，确保生成一致、清晰的文档。

[Doxygen 示例预览](https://viys.github.io/doxygen_stu/)

## 1. 基本语法

Doxygen 注释块通常有以下几种风格：

```c
/** 文档内容 */     // 推荐
/*! 文档内容 */     // 适用于实现文件的注释
/// 文档内容         // 单行风格
//! 文档内容
```

推荐使用 `/** ... */` 风格，统一注释格式。

## 2. 文件注释

每个 `.c` 和 `.h` 文件的顶部应包含文件级别注释。

```c
/**
 * @file    module_name.c
 * @brief   模块功能简要描述
 * @author  Your Name
 * @date    2025-06-08
 * @version 1.0
 */
```

## 3. 函数注释

函数的注释应该放在函数定义/声明之前，包含功能描述、参数、返回值等。

```c
/**
 * @brief  计算两个整数的最大值。
 * 
 * @param[in]  a  第一个整数
 * @param[in]  b  第二个整数
 * 
 * @return 返回较大的那个整数
 */
int max(int a, int b);
```

支持的参数方向标签包括：

- `@param[in]`  输入参数
- `@param[out]` 输出参数
- `@param[in,out]` 输入输出参数

## 4. 结构体注释

```c
/**
 * @brief 表示一个二维点的结构体
 */
typedef struct {
    int x; /**< X 坐标 */
    int y; /**< Y 坐标 */
} Point;
```

字段说明应使用 `/**< ... */` 紧跟在成员之后。

## 5. 宏定义注释

```c
/**
 * @brief 定义圆周率的近似值
 */
#define PI 3.1415926
```

## 6. 枚举注释

```c
/**
 * @brief 表示错误码类型
 */
typedef enum {
    ERROR_NONE = 0,      /**< 没有错误 */
    ERROR_TIMEOUT,       /**< 超时错误 */
    ERROR_OVERFLOW       /**< 溢出错误 */
} ErrorCode;
```

## 7. 全局变量/静态变量注释

```c
/**
 * @brief 系统启动标志位
 */
static int g_system_started = 0;
```

## 8. 注释标签速查表

| 标签               | 说明                     |
| ------------------ | ------------------------ |
| `@file`            | 当前文件名称             |
| `@brief`           | 简要描述                 |
| `@details`         | 详细描述                 |
| `@param`           | 参数说明                 |
| `@return`          | 返回值说明               |
| `@retval`          | 返回值定义说明（多个值） |
| `@note`            | 注意事项                 |
| `@warning`         | 警告信息                 |
| `@see`             | 相关链接                 |
| `@code`/`@endcode` | 代码块                   |

## 9. 代码块示例

```c
/**
 * @code
 * int value = max(5, 10);
 * printf("Max = %d\n", value);
 * @endcode
 */
```

## 10. 示例组织结构（推荐）

```txt
project/
├── include/
│   └── module.h      <- 文件注释 + 结构体/函数声明注释
├── src/
│   └── module.c      <- 文件注释 + 函数定义注释
├── docs/
│   └── DOXYGEN_STYLE.md <- 本文档
└── Doxyfile           <- Doxygen 配置文件
```

## 11. 附加建议

- 尽量为每个函数和类型都添加注释；
- 保持注释语言统一（中英文均可，但尽量统一）；
- 如果使用 Kconfig，Kconfig 也支持注释用于 Doxygen（如 `#` 开头的注释）。

如需添加首页简介，请在 `Doxyfile` 中配置：

```txt
USE_MDFILE_AS_MAINPAGE = README.md
```

或将 `@mainpage` 标签添加到某个注释块：

```c
/**
 * @mainpage 项目名称
 *
 * @section intro_sec 简介
 * 本项目实现了……
 *
 * @section install_sec 安装
 * 安装方式如下……
 */
```