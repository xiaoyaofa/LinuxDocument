## pip
### pip3安装
python -m ensurepip --upgrade
### 切换pip源
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

## 虚拟环境
python3 -m venv myenv
source myenv/bin/activate
## 安装第三方包
pip install xxx-package -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com