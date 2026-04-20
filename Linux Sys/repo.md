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

查看特定时间段的提交
```
repo forall -c 'git log --since="1 weeks ago"'
```
