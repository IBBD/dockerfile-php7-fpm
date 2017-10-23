# PHP7 FPM 镜像 For Laravel and Lumen

该镜像主要使用于接口服务。


## 更新记录

### 2017.10.23
- 升级到7.1.10
- msgpack更新到stable版本

### 2017.07.24
- 升级到7.1.7

### 2017.04.28
- 升级到7.0.18

### 2017.03.26
- 升级到7.0.17

### 2016.09.22

- 升级到7.0.11

### 2016.09.06

- 增加gd库
- 升级到7.0.10

### 2016.07.01

- 补上`pdo_mysql`扩展

### 2016.06.26

- 版本升级到`7.0.8`

### 2016.05.20

- 初始版本`php:7.0.6-fpm`

## 基础说明

该镜像主要为满足 `laravel5` 框架而制作，并附加了 `redis`, `mongo`, `msgpack`, `gd`等扩展。

说明：

- [x] 基础镜像：[php-fpm](https://hub.docker.com/_/php)
- [ ] 如果需要phpunit，xdebug，pman等测试及开发工具，请使用`ibbd/php-fpm-dev`镜像，对应的dockerfile在目录`php-fpm-dev`下。
- [ ] 如果只是使用php的命令行，可以使用对应的cli镜像（含swoole）：`ibbd/php-cli`和`ibbd-cli-dev`

## PHP扩展 

- zip
- mcrypt
- mysql相关：mysqli, pdo
- mongodb
- msgpack 
- gd
- redis

说明：

- pdo, tokenizer, iconv, mbstring都已经包含在基础镜像`php:7-fpm`中

附加安装

- composer（全局安装）
- Laravel Installer: 文档https://laravel.com/docs/
- Lumen Installer: 文档https://lumen.laravel.com/docs/

## 安装 

- Pull: `sudo docker pull ibbd/php7-fpm`

## 使用

```sh
# 代码目录
code_path=/var/www

# 日志目录
logs_path=/var/log/php

current_path=$(pwd)
docker run --name=ibbd-php7-fpm -d \
    -p 9000:9000 \
    -v $code_path:/var/www \
    -v $logs_path:/var/log/php \
    -v $current_path/conf/php.ini:/usr/local/etc/php/php.ini:ro \
    -v $current_path/conf/php-fpm.conf:/usr/local/etc/php-fpm.conf:ro \
    ibbd/php-fpm \
    php-fpm -c /usr/local/etc/php/php.ini -y /usr/local/etc/php-fpm.conf
```


