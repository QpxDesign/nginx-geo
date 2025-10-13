FROM ubuntu:24.04

RUN apt-get update
RUN apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev # NGINX deps
RUN apt install -y wget make build-essential git # Other deps
RUN apt update && apt-get install nginx=1.24.0-2ubuntu7.5 -y

RUN mkdir /usr/lib/nginx-geo
WORKDIR /usr/lib/nginx-geo

# 1. Install libmaxminddb (https://github.com/maxmind/libmaxminddb)
RUN wget https://github.com/maxmind/libmaxminddb/releases/download/1.12.2/libmaxminddb-1.12.2.tar.gz
RUN tar zxvf libmaxminddb-1.12.2.tar.gz
WORKDIR libmaxminddb-1.12.2
RUN ./configure
RUN make
RUN make check
RUN make install
RUN ldconfig
WORKDIR /usr/lib/nginx-geo

# 2. Install NGINX Module (https://github.com/leev/ngx_http_geoip2_module)
RUN git clone https://github.com/leev/ngx_http_geoip2_module
RUN wget http://nginx.org/download/nginx-1.24.0.tar.gz
RUN tar zxvf nginx-1.24.0.tar.gz
WORKDIR nginx-1.24.0
RUN ./configure --with-compat --add-dynamic-module=/usr/lib/nginx-geo/ngx_http_geoip2_module
RUN make modules
RUN rm /usr/share/nginx/modules
RUN mkdir /usr/share/nginx/modules/
RUN mv /usr/lib/nginx-geo/nginx-1.24.0/objs/ngx_http_geoip2_module.so /usr/share/nginx/modules/
WORKDIR /usr/lib/nginx-geo


EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
#RUN sed -i "1iload_module modules/ngx_http_geoip2_module.so;" /etc/nginx/nginx.conf
