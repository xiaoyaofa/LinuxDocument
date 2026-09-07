## 基本概念
Overlayfs是一种堆叠文件系统，它依赖并建立在其它的文件系统之上（例如ext4fs和xfs等等），并不直接参与磁盘空间结构的划分，仅仅将原来底层文件系统中不同的目录进行“合并”，然后向用户呈现。
### Upper 和 Lower
overlay 文件系统组合了两个文件系统 - 一个“upper”文件系统和一个“lower”文件系统。当一个名称同时存在于两个文件系统中时，“upper”文件系统中的对象是可见的，而“lower”文件系统中的对象要么被隐藏，要么（在目录的情况下）与“upper”对象合并。
更准确的说法是 upper 和 lower “目录树”，而不是“文件系统”，因为两个目录树都可能位于同一文件系统中，并且 upper 或 lower 都不需要提供文件系统的根目录。
Linux 支持的各种文件系统都可以作为 lower 文件系统，但并非所有 Linux 可以挂载的文件系统都具有 OverlayFS 工作所需的特性。lower 文件系统不需要是可写的。lower 文件系统甚至可以是另一个 overlayfs。upper 文件系统通常是可写的，如果是可写的，则必须支持创建 trusted.* 和/或 user.* 扩展属性，并且必须在 readdir 响应中提供有效的 d_type，因此 NFS 不适用。

## 创建分区
查看GPT分区信息
```
sgdisk -p /dev/mmcblk1
```
删除对应分区
```
sgdisk -d 9 /dev/mmcblk1
```
刷新分区表
```
partx -u /dev/mmcblk1
```
创建 overlay 分区
创建新分区：使用全部剩余空间
    -n 9:0:0  = 分区号 9，起始扇区默认（0=自动），结束扇区默认（0=最大）
    -t 9:8300 = 分区类型 Linux filesystem
    -c 9:overlay = 分区名称
```
sgdisk -n 9:0:0 -t 9:8300 -c 9:overlay /dev/mmcblk1
```

格式化分区
```
mkfs.ext4 -L overlay /dev/mmcblk1p9
```
## 挂载overlayfs
```
mkdir -p /data/overlay/upper /data/overlay/work /home/root/lower /home/root/merged
```
初始化 lower 层(模拟只读文件系统)
```
echo 'original file' > /home/root/lower/original.txt
mkdir -p /home/root/lower/subdir
echo 'lower file in subdir' > /home/root/lower/subdir/data.txt
echo 'this file should not change' > /home/root/lower/readonly.txt
```
lowerdir  - 只读下层
upperdir  - 可写上层（必须在 overlay 分区上）
workdir   - 工作目录（必须与 upper 在同一文件系统）
merged    - 联合挂载后的视图，用户通过它访问文件系统
```
mount -t overlay overlay \
  -o lowerdir=/home/root/lower,upperdir=/data/overlay/upper,workdir=/data/overlay/work \
  /home/root/merged
```
验证合并视图
merged 中看到与 lower 完全相同的 3 个文件
```
ls /home/root/merged
```
### 验证新建文件
在merged中创建新文件
```
echo 'new file created via overlay' > /home/root/merged/newfile.txt
```
查看upper层
```
$ ls /data/overlay/upper/
newfile.txt
```
查看lower层
```
$ ls /home/root/lower
original.txt  readonly.txt  subdir
```
可以看到新文件只存在于 upper 层，lower 层不受影响
### 修改文件
在merged中修改lower的文件
```
$ cat  /home/root/merged/original.txt 
original file
$ echo test > /home/root/merged/original.txt 
$ cat  /home/root/merged/original.txt 
test
```
查看lower和upper
```
$ cat /home/root/lower/original.txt 
original file
$ cat /data/overlay/upper/original.txt 
test
```