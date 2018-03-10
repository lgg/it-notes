# Nginx configs

Some samples for nginx configurations

## Configs:

### Basic configs

* common directory
    * common files for 
        * php5 for php5
        * and php for php7
        * errors
        * allow/deny access to hidden files
    * common/files
        * it is optional file for default favicon and robots.txt file
* wordpress
    * by default wp-login page is protected with web auth
        * you can comment it 
        * or create web auth file: `htpasswd -c /var/www/site.com/.htpasswd YOURUSERNAME`
        * create
* zsecurity
    * it is file for handling all other connections to your `site.com` or ip
    * it's also optional
    * be default it drops unhandled connections
    * you will need to create self-signed certificate for handling ssl connections
    * if you use phpmyadmin config and it serves different port(not 80 and not 443), 
        then uncomment `PMA section` in `zsecurity` file
* for SSL connections configs use let's encrypt path by default,
    you can also change them

### PHPMyAdmin config

* *(optional) you can change port in config file, be default it is `13337`*
* create symlink for `/usr/share/phpmyadmin` on `/usr/share/db-admin`
    * `ln -sT `
* create htpasswd file `/etc/nginx/pass/.pma` for web auth
    * `htpasswd -c /etc/nginx/pass/.pma YOURUSERNAME`
* create symlink `ln -sT /usr/share/phpmyadmin /usr/share/db-admin`
* phpmyadmin will be available on `https://site.com:13337/db-admin/`

## Enabling config

Nginx stores available configs in: `/etc/nginx/sites-available/`. 
To make them enabled you will need to create symlink for them in `/etc/nginx/sites-enabled`.
And reload nginx. You can use this commands: 

* `cd /etc/nginx/sites-enabled`
* `ln -sT ../sites-available/site.com site.com`
* `service nginx reload`

## SSL tips

* to create ssl on another port (e.g. on 8080)
```
listen 8080 ssl;
```

* https-strict header(if you use force ssl)
```
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload;";
```

* if you want to handle error(The plain HTTP request was sent to HTTPS port), when ssl is on another port(not 443) and somebody http://site.com:8888
```
# This will redirect to google.com in this case
error_page 497 https://google.com;
```

## License

* MIT