## 打包
工具链环境变量记得加
```
D:\Qt\5.14.2\mingw73_32\bin;D:\Qt\5.14.2\msvc2017_64\bin;D:\Qt\Tools\QtCreator\bin
```
找到qt工具链路径的windeployqt.exe
D:\Qt\5.14.2\mingw73_32\bin\windeployqt.exe
把要打包的.exe单独拷出来放一个文件夹
C:\Windows\System32\cmd.exe /A /Q /K D:\Qt\5.14.2\mingw73_32\bin\qtenv2.bat
运行导入qt环境变量的cmd终端
执行打包
```
D:\Qt\5.14.2\mingw73_32\bin\windeployqt.exe xxx.exe
```

## 三方攻击打包
Enigma Virtual Box
