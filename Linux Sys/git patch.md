## git生成补丁
git log 查看提交的id
从xxx提交的第n个算起
```
git format-patch xxxxxxxxxxxxx(commit id) -n
```
对比两个commit生成补丁
```
git diff <old commit> <new commit> > xxx.patch
```
基于上一次内容打包
HEAD^^就是上两次
```
git format-patch HEAD^
```


## diff生成补丁
查看文件差异
```
diff test1.sh test2.sh > xxx.diff
```
查看差异，包含头部信息
```
diff -u test1.sh test2.sh
```

## 应用补丁
git apply xxx(补丁名字)
撤回补丁
git apply -R xxx(补丁名字)

debug
export GIT_TRACE=1