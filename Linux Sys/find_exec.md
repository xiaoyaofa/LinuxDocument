ls -l命令放在find命令的-exec选项中
找到当初目录普通文件并ls -l出来
```
find . -type f -exec ls -l {} \;
```
找到out文件夹中的.c文件，并cp到指定tmp文件夹
```
find "out" -type f -name "*.c"  -exec cp {} tmp \;
```