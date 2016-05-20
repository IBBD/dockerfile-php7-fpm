#
# PHP Dockerfile
# 满足laravel5.1版本的基本要求
#
# https://github.com/ibbd/dockerfile-php7-fpm
#
# sudo docker build -t ibbd/php7-fpm ./
#

# Pull base image.
FROM php:7.0.6-fpm

MAINTAINER Alex Cai "cyy0523xc@gmail.com"

# Install modules
# composer需要先安装zip
# pecl install imagick时需要libmagickwand-dev。但是这个安装的东西有点多，python2.7也安装了
        #libfreetype6-dev \
        #libjpeg62-turbo-dev \
        #libpng12-dev \
        #libmagickwand-dev \
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        libmcrypt-dev \
        libssl-dev \
    && apt-get autoremove \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*


#COPY ext/msgpack.tgz  /msgpack.tgz 
#COPY ext/composer.php /composer.php

# install php modules
# pecl install php modules
    #&& docker-php-ext-install gd \
    #&& pecl install mongo \
    #&& echo "extension=mongo.so" > /usr/local/etc/php/conf.d/mongo.ini \
    #&& pecl install memcache \
    #&& echo "extension=memcache.so" > /usr/local/etc/php/conf.d/memcache.ini \
    #&& pecl install imagick-beta \
    #&& echo "extension=imagick.so" > /usr/local/etc/php/conf.d/imagick.ini \
RUN  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install iconv mcrypt pdo pdo_mysql tokenizer mbstring zip mysqli \
    && pecl install redis \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
    && pecl install msgpack-beta \
    && echo "extension=msgpack.so" > /usr/local/etc/php/conf.d/msgpack.ini \
    && pecl install mongodb \
    && echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini \
    && pecl clear-cache

# composer 
# composer中国镜像
# 注意：需要先安装lumen，在安装laravel，否则报错
# 不应在镜像中绑定国内的镜像，因为镜像可能会用到国外的服务器
# 测试国内的容易抽风。。
    #&& curl -sS https://getcomposer.org/installer -o /composer.php \
    #&& php composer.php \
    #&& mv composer.phar /usr/local/bin/composer \
    #&& composer config -g repo.packagist composer http://packagist.phpcomposer.com \
    #&& rm -f composer.php \
    #&& chmod 755 /usr/local/bin/composer \
    #&& php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === 'fd26ce67e3b237fffd5e5544b45b0d92c41a4afe3e3f778e942e43ce6be197b9cdc7c251dcde6e2a52297ea269370680') { echo 'Installer verified';  } else { echo 'Installer corrupt'; unlink('composer-setup.php');  }" \
RUN cd / \
    && php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php \
    && php composer-setup.php  --filename=composer  --install-dir=/usr/local/bin/ \
    && rm composer-setup.php \
    && composer global require "laravel/lumen-installer" \
    && composer global require "laravel/installer" \
    && composer clearcache \
    && composer clear-cache


# 解决时区问题
ENV TZ "Asia/Shanghai"

# 终端设置
# 执行php-fpm时，默认值是dumb，这时在终端操作时可能会出现：terminal is not fully functional
ENV TERM xterm

# Define mountable directories.
VOLUME /var/www

# 工作目录
WORKDIR /var/www 

EXPOSE 9000
