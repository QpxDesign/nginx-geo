# nginx-geo:

## a script to add ip address lookups to your nginx.conf

### Install

1. Clone this repository
2. Edit `nginx-geo.sh` with the path to nginx-geo and your currently installed version of nginx
3. Run the script: `sudo bash nginx-geo.sh`
4. Download [MaxMind Databases](https://dev.maxmind.com/geoip/geolite2-free-geolocation-data/)
5. Add the following to the `http` block of your `nginx.conf`: ()

```
    geoip2 /root/nginx-geo/db/GeoLite2-ASN.mmdb { # REPLACE WITH PATH TO GEOLITE DB LOCATION
	$geoip2_asn_org source=$http_x_forwarded_for autonomous_system_organization;
	$geoip2_asn source=$http_x_forwarded_for autonomous_system_number;
    }
    geoip2 /root/nginx-geo/db/GeoLite2-City.mmdb { # REPLACE WITH PATH TO GEOLITE DB LOCATION

        $geoip2_data_city_name default=EagleRock city names en;
    }
    # Optional (add these variables to your access.log)
    log_format main '$http_x_forwarded_for - $remote_user [$time_local] "$host" "$request" '
            '$status $body_bytes_sent "$http_referer" '
           '"$http_user_agent" $request_time <$geoip2_data_city_name> -- ($geoip2_asn_org, $geoip2_asn)';
```

### Sources

- [ngx_http_geoip2_module](https://github.com/leev/ngx_http_geoip2_module)
- [libmaxminddb](https://github.com/maxmind/libmaxminddb)
- [nginx](https://nginx.org)
