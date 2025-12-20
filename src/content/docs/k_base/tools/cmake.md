---
title: CMake 相关
---

https://cmake.org/documentation/

# CMake 命令行参数：

1. `-S <path>` 指定源代码的路径（CMakeLists.txt 文件所在目录）。 示例：`cmake -S /path/to/source`
2. `-B <path>` 指定构建输出的路径（构建目录）。 示例：`cmake -B /path/to/build`
3. `-G <generator>` 指定构建工具生成器，例如 `Ninja`、`Unix Makefiles`、`Visual Studio` 等。 示例：`cmake -G "Unix Makefiles"`
4. `-D <var>=<value>` 设置 CMake 变量。可以在配置过程中指定特定的变量值。 示例：`cmake -D CMAKE_BUILD_TYPE=Release`
5. `-C <initial_cache>` 加载一个初始的 CMake 缓存文件。 示例：`cmake -C initial_cache.cmake`
6. `--build <path>` 在指定的构建目录中启动构建过程。可以附加 `--target` 参数指定构建目标。 示例：`cmake --build /path/to/build`
7. `--target <target_name>` 指定构建的目标名称。 示例：`cmake --build . --target install`
8. `--clean-first` 在开始构建之前先清除先前的构建。 示例：`cmake --build . --clean-first`
9. `--parallel [N]` 指定并行构建的最大任务数，默认是 `1`。 示例：`cmake --build . --parallel 4`
10. `-T <toolchain_file>` 指定工具链文件，用于交叉编译等场景。 示例：`cmake -T /path/to/toolchain.cmake`
11. `--install <path>` 安装构建的项目到指定目录。 示例：`cmake --install . --prefix /path/to/install`
12. `--help` 显示 CMake 的帮助信息。 示例：`cmake --help`
13. `-LA` 列出所有 CMake 缓存变量。 示例：`cmake -LA`
14. `-LAH` 列出所有 CMake 缓存变量，并显示它们的帮助信息。 示例：`cmake -LAH`