# DNS

| Host name      | Type              | Data            | Result          |
| :------------: | :---------------: | :-------------: | :-------------: |
| @ (or empty)   | A                 | 666.666.666.666 | example.com     |
| www            | A                 | 666.666.666.666 | www.example.com |

Vercel DNS:

    76.76.21.241
# NGINX

```
# HTTP (Port 80)
server {
    # if ($host = example.com) {
    #     return 301 https://$host$request_uri;
    # } # managed by Certbot

    listen 80;
    listen [::]:80;
    server_name example.com www.example.com localhost;
    return 301 https://$host$request_uri;
    return 404; # managed by Certbot
}

# HTTPS - SSL (Port 443)
server {
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on;
    server_name example.com www.example.com localhost;
    
    #==========SSL CONFIGURATION==========#
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
    #==========SSL CONFIGURATION==========#
    
    #==========STATIC CONTENT==========#
    # root /var/www/html;
    root /var/www/app;

    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
    #==========STATIC CONTENT==========#
    
    #==========REVERSE PROXY==========#
    location / {
        proxy_pass http://apache2;
    }
    #==========REVERSE PROXY==========#
}

#==========REVERSE PROXY==========#
upstream apache2 {
    server example.com:5000;
    # server host.docker.internal:5000;
}
#==========REVERSE PROXY==========#
```