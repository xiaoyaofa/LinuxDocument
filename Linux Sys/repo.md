## 安装
mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo  > ~/bin/repo
chmod a+x ~/bin/repo

export REPO_URL='https://mirrors.cernet.edu.cn/git-repo'

## 使用
初始化
```
repo init -u https://github.com/xxx.git --no-clone-bundle --depth=1 -m myir-xxx.xml -b xxx
```
同步
```
repo sync
```
查看各仓库当前分支
```
repo forall -c 'git branch --show-current'
```
或
```
repo status
```

查看特定时间段的提交
```
repo forall -c 'git log --since="1 weeks ago"'
```
对所有仓库创建test分支并切换
```
repo start test --all
```
只对指定仓库
```
repo start test <project-name>
```
