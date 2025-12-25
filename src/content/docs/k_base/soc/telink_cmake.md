---
title: Telink Zigbee SDK CMake 工程
---

# Telink Zigbee SDK CMake 示例工程
> 项目地址：https://github.com/viys/tlsr_zigbee_sdk_cmake

本仓库将 Telink Zigbee SDK 通过 CMake 组织，并提供 PowerShell 脚本在 Windows 上完成一键编译与固件合并。

## 目录结构
```powershell
tlsr_zigbee_sdk_cmake/
|-- CMakeLists.txt             # 根 CMake，汇总 SDK/工程源码并生成 elf/bin
|-- cmake/
|   |-- CMakeLists.txt         # 收集 SDK 源码/头文件
|   |-- config.cmake           # 项目配置入口
|   |-- functions.cmake        # CMake 辅助函数
|   |-- link.cmake             # 链接脚本与 Zigbee 库选择
|   `-- toolchain.cmake        # TC32 交叉编译器与编译选项
|-- project/
|   `-- CMakeLists.txt         # 应用源文件收集（sampleLight/common）
|-- tl_zigbee_sdk/             # Telink Zigbee SDK 源码及预编译库
|-- bootloader/                # BootLoader 二进制
|-- tools/                     # 辅助工具（srec_cat、tl_check_fw2 等）
|-- build/                     # out-of-tree 构建产物目录
`-- build.ps1                  # PowerShell 构建脚本
```

## 环境要求
- Windows（PowerShell 5+/7+ 均可）。
- CMake ≥ 3.10（脚本使用 `Unix Makefiles` 生成器）。
- Telink TC32 交叉编译工具链，需保证 `tc32-elf-gcc`、`tc32-elf-objcopy` 等命令在 `PATH` 中；如前缀不同，可在 `cmake/config.cmake` 中调整。
- 工具链之外的校验/合并工具已随仓库提供：`tools/telink_script/tl_check_fw2.exe`、`tools/srecord/srec_cat.exe`。

## 配置说明（cmake/config.cmake）
关键变量：
- `TELINK_PROJECT_NAME`：工程名，决定生成的 elf/bin 前缀（默认 `sampleLight`）。
- `TELINK_MCU_CORE`：芯片架构，支持 `8258`/`b91`，用于选择启动文件与平台源码。
- `TELINK_BOOTLOADER_FILE`：`bootloader/` 目录下的 BootLoader 文件名。
- `TELINK_MERGEN_NAME`：合并后固件文件名，若不变量为空则不进行固件合成。
- `TELINK_TOOLCHAIN_PATH`：交叉编译器前缀（如 `tc32-elf-` 或绝对路径前缀）。
- `TELINK_TOOLCHAIN_NAME`：供 `build.ps1` 检测工具链使用，如未设置可补充 `set(TELINK_TOOLCHAIN_NAME tc32-elf-)`。
- `TELINK_LINKER_SCRIPT`：链接脚本路径。
- `TELINK_EQUIP_TYPE`：`ZR`/`ZC`/`ZED`，决定链接的 Zigbee 库。
- `TELINK_BOOTLOADER_IMAGE`、`TELINK_RAMCODE_MAX`、`TELINK_FW_OFFSET`：固件偏移及 RAM code 预留等参数。
- `TELINK_COMPILE_DEFINITIONS`：编译宏列表，已包含 `MCU_CORE_8258`、`ROUTER` 等。

## 使用 PowerShell 构建（推荐）
`build.ps1` 会创建 `build/` 目录，运行 CMake 配置、编译，并调用工具完成校验与合并：
```powershell
./build.ps1 all
```
其他常用命令：
- `./build.ps1 cmake`：仅生成构建文件（`build/` 下 `Unix Makefiles`）。
- `./build.ps1 make`：在已有构建文件上编译，完成后自动合并 BootLoader 与应用 bin。
- `./build.ps1 clean`：调用 `cmake --build . --target clean`。
- `./build.ps1 delete`：删除 `build/` 目录。

脚本默认并行构建（核心数），并在编译完成后生成 `.elf`、`.bin`、`.map`，再使用 `srec_cat` 依据 `TELINK_FW_OFFSET` 生成合并固件。

## 手动构建示例
如需手工执行等价步骤（可按需替换文件名/偏移）：
```powershell
cmake -S . -B build -G "Unix Makefiles"
cmake --build build --parallel
tools\srecord\srec_cat.exe bootloader\bootLoader_8258.bin -binary build\sampleLight.bin -binary -offset 0x9000 -o build\sampleLight_MERGEN.bin -binary
```

## 生成产物
- `build/<PROJECT>.elf`：含符号信息的可执行文件。
- `build/<PROJECT>.bin`：应用裸 bin。
- `build/<PROJECT>.map`：链接映射。
- `build/<MERGEN>.bin`：合并 BootLoader + 应用的最终固件。
