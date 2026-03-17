## 下载
curl -fsSL https://ollama.com/install.sh | sh

或者github下载
https://github.com/ollama/ollama/releases

解压后
export PATH="/usr/local/ollama/bin:$PATH"
## 配置
systemd服务
vi /lib/systemd/system/ollama.service
```
[Unit]
Description=ollama service
After=network-online.target

[Service]
ExecStart=/usr/local/ollama/bin/ollama serve
User=root
Group=root
Restart=always
RestartSec=3
Environment="PATH=/usr/local/ollama/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
#指定模型的存储位置
#Environment="OLLAMA_MODELS=/usr/local/ollama/models"
Environment="OLLAMA_MODELS=/run/media/a-sda1/modules"

[Install]
WantedBy=default.target
```
systemctl daemon-reload
systemctl start ollama.service
查看是否正常工作
systemctl status ollama.service

下载模型
ollama pull deepseek-r1:1.5b
查看模型列表
ollama list
运行
ollama run deepseek-r1:1.5b

