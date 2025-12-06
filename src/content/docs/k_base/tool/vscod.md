---
title: VSCode 相关
---

# C 语言代码提示

在 Ubuntu 上使用 VSCode 进行 C 语言开发时，如果没有代码提示，通常是由于缺少配置或插件的问题。你可以按以下步骤进行检查和解决：

1. **安装** **C/C++** **插件**：
   1. 确保你已经安装了 VSCode 的官方 C/C++ 插件。
   2. 打开 VSCode 后，按 `Ctrl+P`，输入 `ext install ms-vscode.cpptools` 安装插件。
2. **检查编译器路径**：
   1. 打开 VSCode 设置 (`Ctrl+,`) ，搜索 `C_Cpp: Default Compiler Path`。
   2. 确保编译器路径指向你的 GCC 或 Clang 编译器，例如：
   3. `/usr/bin/gcc`
3. **配置** **`c_cpp_properties.json`**：
   1. 打开你的工作区，按 `Ctrl+Shift+P`，搜索 `C/C++: Edit Configurations (UI)`，然后设置路径。
   2. 如果没有自动生成配置文件，你可以手动创建 `.vscode/c_cpp_properties.json`，例如：
   3. `{  "configurations": [    {      "name": "Linux",      "includePath": [        "${workspaceFolder}/**",        "/usr/include",        "/usr/local/include"      ],      "defines": [],      "compilerPath": "/usr/bin/gcc",      "cStandard": "c11",      "cppStandard": "c++17",      "intelliSenseMode": "gcc-x64"    }  ],  "version": 4 } `
4. **检查 Clangd 插件**：
   1. 如果你使用的是 `clangd` 插件，确保它已正确配置。
   2. 你可以通过 VSCode 的扩展市场安装 `clangd` 插件，并在设置中配置 `clangd` 路径。
5. **配置 CMake**（如果你使用 CMake）：
   1. 安装 `CMake Tools` 插件并确保 CMake 配置文件正确。
   2. 可以通过 `Ctrl+Shift+P`，选择 `CMake: Configure` 来配置项目。
6. **检查日志**：
   1. 你可以打开 VSCode 的输出控制台 (`Ctrl+Shift+U`)，选择 C/C++ 插件，查看是否有任何错误信息。

你可以按照以上步骤检查并确保 VSCode 已正确配置来启用代码提示。如果问题仍然存在，可以提供更多细节，我会进一步帮你排查。

# 关闭 CMake 自动生成

## 关闭打开时自动生成

要在 VSCode 中关闭 CMake 的自动生成，可以按照以下步骤操作：

1. **打开 VSCode 的设置**：
   1. 点击左下角的齿轮图标，选择“设置”。
2. **搜索 CMake 设置**：
   1. 在搜索栏中输入 `CMake: Configure On Open`。
3. **修改配置**：
   1. 将 `CMake: Configure On Open` 选项取消勾选。这将禁止 CMake 在打开工作区时自动生成。
4. **保存设置**：
   1. 关闭设置页面，设置会自动保存。

这样就可以防止 VSCode 在打开项目时自动执行 CMake 生成。你可以手动使用命令面板或终端进行生成。

## 关闭修改时自动生成

要在 VSCode 中关闭 CMake 修改文件后自动生成的功能，可以按照以下步骤操作：

1. **打开 VSCode 的设置**：
   1. 点击左下角的齿轮图标，选择“设置”。
2. **搜索 CMake 设置**：
   1. 在搜索栏中输入 `CMake: Auto Configure`。
3. **修改配置**：
   1. 将 `CMake: Auto Configure` 选项取消勾选。这将禁止 CMake 在文件修改后自动生成。
4. **保存设置**：
   1. 关闭设置页面，设置会自动保存。

完成这些步骤后，CMake 将不再在你修改文件后自动生成，你可以手动控制何时进行配置和生成。