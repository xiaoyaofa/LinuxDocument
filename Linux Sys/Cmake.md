## CMakeLists.txt配置
设置交叉编译环境
```
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
```
设置交叉工具链
```
set(CMAKE_C_COMPILER "aarch64-oe-linux-gcc")
set(CMAKE_CXX_COMPILER "aarch64-oe-linux-g++")
```

将子目录添加到构建过程
```
add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
```
指定包搜索路径
```
find_package(xxx REQUIRED
			 PATHS /home/path
			 NO_DEFAULT_PATH)
```