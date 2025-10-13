#!/bin/bash
PATH_TO_NGINXGEO="/user/lib/nginx-geo"

# Dynamically Set NGINX Version:
NGINX_VERSION=$(nginx -v 2>&1 | grep -oP 'nginx/\K[0-9.]+')

# 1. Install libmaxminddb (https://github.com/maxmind/libmaxminddb)
wget https://github.com/maxmind/libmaxminddb/releases/download/1.12.2/libmaxminddb-1.12.2.tar.gz
tar zxvf libmaxminddb-1.12.2.tar.gz
cd libmaxminddb-1.12.2
./configure
make
make check
sudo make install
sudo ldconfig
cd ..

# 2. Install NGINX Module (https://github.com/leev/ngx_http_geoip2_module)
git clone https://github.com/leev/ngx_http_geoip2_module
wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
tar zxvf nginx-$NGINX_VERSION.tar.gz
cd nginx-$NGINX_VERSION
./configure --with-compat --add-dynamic-module=$PATH_TO_NGINXGEO/ngx_http_geoip2_module
make modules
cp objs/ngx_http_geoip2_module.so /etc/nginx/modules/
cd ..
sed -i "1iload_module modules/ngx_http_geoip2_module.so;" /etc/nginx/nginx.conf

# x. Clean Up
cd $PATH_TO_NGINXGEO
rm nginx-$NGINX_VERSION.tar.gz
rm libmaxminddb-1.12.2.tar.gz
