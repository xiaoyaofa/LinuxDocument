## 配置
查询配置
git config --global --list

设置用户名和email
```
git config --global user.name “要修改的名字”
git config --global user.email “要修改的邮箱”
```
全局使用git镜像
```
git config --global url."https://bgithub.xyz".insteadOf https://github.com
git config --global url."git://bgithub.xyz".insteadOf git://github.com
# 设置HTTP代理
git config --global http.proxy http://127.0.0.1:7897
```
查看当前代理
```
git config --get --global http.proxy
```
取消 HTTP 和 HTTPS 代理
```
git config --global --unset http.proxy
```
取消配置
```
git config --global --unset url."https://bgithub.xyz".insteadOf
```
设置ssh代理
```
GIT_SSH_COMMAND="ssh -o ProxyCommand='nc -X 5 -x 127.0.0.1:7897 %h %p'" \
git clone git@github.com:xxxxx
```

## 初始化
```
git init
```

暂存添加所有文件
```
git add .
```
只暂存已跟踪的文件
```
git add -u .
```

```
git commit -m "信息"
```

关联仓库
```
git remote add origin git@github.com:helloWorldchn/test.git
```
推送
```
git push origin main
```
验证
```
ssh -T git@github.com
```

## 标签
查看标签
git tag
为了签出 Git 标签，我们将使用以下命令 git checkout 命令，我们必须指定标签名称和必须签出以保存在本地分支中的分支。
```
git checkout tags/<tag> -b <branch>
```

## 分支
删除分支
```
git branch -d <branch>
```
只克隆某一个分支
```
git clone -b <branch> --single-branch <URL>
```

## 远程
### 查看当前远程仓库
```
git remote -v
```
origin     指向你自己在 GitHub 上的仓库
upstream   通常指向原始仓库

保持本地代码与原始仓库同步
```
git fetch upstream
git merge upstream/<branch>
```
添加远程仓库
```
git remote add origin xxx
```
修改远程仓库
```
git remote set-url origin xxx
```
### 查看上游提交记录
```
git log upstream/master --oneline -20
```
同步上游提交
```
git cherry-pick <commit id>
```
查看远程分支
```
git remote show origin
```
### 只克隆指定目录
```
git config core.sparseCheckout true
git remote add origin https://github.com/Microchip-Ethernet/EVB-KSZ9477.git
## 设置Sparse Checkout 为true
git config core.sparsecheckout true
## 将要部分clone的目录相对根目录的路径写入配置文件
echo "KSZ/linux-drivers/ksz8895/linux-6.1" >> .git/info/sparse-checkout
## 浅克隆
git pull --depth 1 origin master 
```

## 删除
删除一个文件
```
git rm test.txt
```
如果文件已经被修改，可以强制删除
```
git rm -f test.txt
```
从 Git 跟踪中移除文件，但保留在工作目录
```
git rm --cached test.txt -r
```

## git stash

保存所有未暂存文件的修改
```
git stash push --keep-index -m "tmp"
```

保存所有文件已跟踪的修改
```
git stash push -m "tmp"
```

查看stash列表
```
git stash list
```
恢复最近一次保存并删除该记录
```
git stash pop
```
恢复指定 stash，但保留记录
```
git stash apply stash@{1}
```


## 杂项
撤销修改，并保留工作区修改
HEAD^ 表示上一个版本，即上一次的commit，也可以写成HEAD~1
```
git reset HEAD~1
```
修改之前提交信息
```
git commit --amend
```
只打包已提交到仓库的文件，并自动排除 .git 目录和 .gitignore 中指定的文件
```
git archive --format=tar.gz --prefix=test/ -o test.tar.gz HEAD
```
拉取特定文件
```
git archive --remote=https://github.com/MontaVista-OpenSourceTechnology/source-mirror --output=./ HEAD:avalon-framework-api-4.3-src.tar.gz
```