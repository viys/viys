---
title: Cppcheck 的使用
---

>  Cppcheck 工具主要用于静态代码分析，帮助开发者在不运行代码的情况下发现潜在的错误、代码质量问题或性能隐患。

# Cppcheck 安装

```bash
sudo apt install cppcheck
```

# Cppcheck 使用

### 基本用法

```bash
cppcheck [选项] [文件或目录]
```

### 常用命令和选项

1. 检查单个文件

```bash
cppcheck example.cpp
```

1. 检查整个目录（递归分析）

```bash
cppcheck --enable=all path/to/directory
```

1. 启用所有检测规则

```bash
cppcheck --enable=all example.cpp
```

>  默认只执行基本错误检测，加上 `--enable=all` 会启用性能、代码风格等规则。

1. 生成详细报告

```bash
cppcheck --verbose example.cpp
```

1. 输出检查结果到文件

```bash
cppcheck example.cpp 2> report.txt
```

> Cppcheck 的结果默认输出到 `stderr`，用 `2>` 将其重定向到文件。

检查特定类型的错误

```bash
cppcheck --enable=warning,performance example.cpp
```

> 常用类型：

- `warning`：警告。
- `style`：代码风格问题。
- `performance`：性能问题。
- `portability`：跨平台兼容问题。
- `unusedFunction`：未使用的函数。

1. 忽略某些文件或目录

```bash
cppcheck --exclude=path/to/ignore example.cpp
```

1. 指定语言标准

```bash
cppcheck --std=c++17 example.cpp
```

> 支持的标准有：`c89`, `c99`, `c11`, `c++03`, `c++11`, `c++14`, `c++17`, `c++20`。