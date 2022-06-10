#!/bin/sh
# 安装必要依赖
apt update
apt upgrade -y
apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y
# 验证nginx官方签名
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
# 设置用于稳定NGINX软件包的APT存储库
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
# 更新软件源 && 安装nginx
apt update
apt install nginx -y
# 提供 apt 存储库的抽象, 管理你的发行版和独立软件供应商的软件源
sudo apt install software-properties-common -y
# 添加 PHP 软件源
sudo add-apt-repository ppa:ondrej/php -y
# 安装PHP
sudo apt install php7.4-bcmath php7.4-bz2 php7.4-cli php7.4-curl php7.4-fpm php7.4-gd php7.4-igbinary php7.4-imagick \
php7.4-mbstring php7.4-memcached php7.4-msgpack php7.4-mysql php7.4-redis php7.4-sqlite3 php7.4-swoole php7.4-xml -y

# 安装MySQL服务器端
apt install mysql-server-8.0 -y

# 安装docker && docker-compose
apt install ca-certificates curl gnupg lsb-release -y
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# 创建工程目录
mkdir -p /www/logs

# 启动项目
service nginx start
service mysql start
service php7.4-fpm start


# 安装php composer
# 下载安装程序到当前目录
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# 验证安装程序 SHA-384
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
# 运行安装程序
php composer-setup.php
# 删除安装程序
php -r "unlink('composer-setup.php');"
# 全局安装
sudo mv composer.phar /usr/local/bin/composer