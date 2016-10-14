# docker-php7-4yii2

php7.0.11-fpm Dockerfile for image to use for development on a yii2 projects

Pass all yii2 check, included xdebug, git and composer with asset-plugin

Example usage

```
version: '2'
services:
  php:
    image: bscheshir/php:7.0.11-fpm-4yii2-xdebug
    ports:
      - "9000:9001"
    volumes:
      - ./php-code:/var/www/html #php-code
    depends_on:
      - db
  nginx:
    image: nginx:1.11.5-alpine
    ports:
      - "8080:80"
    depends_on:
      - php
    volumes_from:
      - php
    volumes:
      - ./nginx-conf:/etc/nginx/conf.d #nginx-conf
      - ./nginx-logs:/var/log/nginx #nginx-logs
  db:
    image: mysql:5.7.15
    volumes:
      - ./mysql-data/db:/var/lib/mysql #mysql-data
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: yaweather
      MYSQL_USER: yaweather
      MYSQL_PASSWORD: yaweather
```

More info:
```
Yii Application Requirement Checker

This script checks if your server configuration meets the requirements
for running Yii application.
It checks if the server is running the right version of PHP,
if appropriate PHP extensions have been loaded, and if php.ini file settings are correct.

Check conclusion:
-----------------

PHP version: OK

Reflection extension: OK

PCRE extension: OK

SPL extension: OK

Ctype extension: OK

MBString extension: OK

OpenSSL extension: OK

Intl extension: OK

ICU version: OK

ICU Data version: OK

Fileinfo extension: OK

DOM extension: OK

PDO extension: OK

PDO SQLite extension: OK

PDO MySQL extension: OK

PDO PostgreSQL extension: OK

Memcache extension: OK

GD PHP extension with FreeType support: OK

ImageMagick PHP extension with PNG support: OK

Expose PHP: OK

PHP allow url include: OK

PHP mail SMTP: OK

------------------------------------------
Errors: 0   Warnings: 0   Total checks: 22

phpinfo()
PHP Version => 7.0.11

System => Linux 123a237a3897 4.4.0-42-generic #62-Ubuntu SMP Fri Oct 7 23:11:45 UTC 2016 x86_64
Build Date => Sep 23 2016 21:47:05
Configure Command =>  './configure'  '--with-config-file-path=/usr/local/etc/php' '--with-config-file-scan-dir=/usr/local/etc/php/conf.d' '--disable-cgi' '--enable-ftp' '--enable-mbstring' '--enable-mysqlnd' '--with-curl' '--with-libedit' '--with-openssl' '--with-zlib' '--enable-fpm' '--with-fpm-user=www-data' '--with-fpm-group=www-data'
Server API => Command Line Interface
Virtual Directory Support => disabled
Configuration File (php.ini) Path => /usr/local/etc/php
Loaded Configuration File => /usr/local/etc/php/php.ini
Scan this dir for additional .ini files => /usr/local/etc/php/conf.d
Additional .ini files parsed => /usr/local/etc/php/conf.d/docker-php-ext-gd.ini,
/usr/local/etc/php/conf.d/docker-php-ext-imagick.ini,
/usr/local/etc/php/conf.d/docker-php-ext-intl.ini,
/usr/local/etc/php/conf.d/docker-php-ext-memcached.ini,
/usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini,
/usr/local/etc/php/conf.d/docker-php-ext-pdo_pgsql.ini,
/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

PHP API => 20151012
PHP Extension => 20151012
Zend Extension => 320151012
Zend Extension Build => API320151012,NTS
PHP Extension Build => API20151012,NTS
Debug Build => no
Thread Safety => disabled
Zend Signal Handling => disabled
Zend Memory Manager => enabled
Zend Multibyte Support => provided by mbstring
IPv6 Support => enabled
DTrace Support => disabled

Registered PHP Streams => https, ftps, compress.zlib, php, file, glob, data, http, ftp, phar
Registered Stream Socket Transports => tcp, udp, unix, udg, ssl, tls, tlsv1.0, tlsv1.1, tlsv1.2
Registered Stream Filters => zlib.*, convert.iconv.*, string.rot13, string.toupper, string.tolower, string.strip_tags, convert.*, consumed, dechunk

This program makes use of the Zend Scripting Language Engine:
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies
    with Xdebug v2.4.1, Copyright (c) 2002-2016, by Derick Rethans


 _______________________________________________________________________

```
