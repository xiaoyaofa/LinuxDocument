### 安装 apache2
```
sudo apt install -y apache2
```
### 配置 apache2
默认是 80 端口，防止其他情况使用导致冲突，修改为自定义端口：8001
```
sudo vim /etc/apache2/ports.conf
```
```
Listen 8001 ## 其它行不变
```
修改文件端口与访问目录，方便后续使用
```
sudo vim /etc/apache2/sites-enabled/000-default.conf
```
```
<VirtualHost *:8001> ## 其他行不变
#DocumentRoot /var/www/html ## 默认浏览器访问目录，注释掉
DocumentRoot /home/xie/apache2 ##修改为此目录，用户名请根据修改做修改
ServerName www.域名.com
```
配置网站访问文件
```
vim /etc/apache2/apache2.conf
```
```
#<Directory /var/www/> ##配置文件默认目录，注释掉
<Directory /home/xie/apache2>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```
重启服务
```
sudo /etc/init.d/apache2 restart
或者
systemctl restart apache2
```
### 卸载
–purge 是不保留配置文件的意思
```
sudo apt –purge remove apache2
sudo apt –purge remove apache2-common
sudo apt –purge remove apache2-utils
sudo apt autoremove apache2
```
```
sudo rm -rf /etc/apache2
sudo rm -rf /var/www
sudo rm -rf /etc/init.d/apache2
```