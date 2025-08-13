@echo off
echo 开始构建GDExtension...

REM 创建构建目录
if not exist "build" mkdir build
cd build

REM 配置CMake项目
echo 配置CMake项目...
cmake .. -G "Visual Studio 17 2022" -A x64

REM 构建项目
echo 构建项目...
cmake --build . --config Release

echo 构建完成！
echo 请检查 bin/windows/ 目录下的输出文件

pause

