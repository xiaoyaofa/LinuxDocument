## x86
wget https://www.openssl.org/source/openssl-3.0.9.tar.gz
tar -zxvf openssl-3.0.9.tar.gz
cd openssl-3.0.9

# 配置安装路径（例如 /usr/local/openssl3）
./config --prefix=/usr/local/openssl3 --openssldir=/usr/local/openssl3/ssl shared
make -j$(nproc)
sudo make install

配置动态链接库路径

## arm64
./config no-asm shared no-async --prefix=$(pwd)/install --cross-compile-prefix=aarch64-linux-gnu-