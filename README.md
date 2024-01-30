### Install ruby on windows
https://reintech.io/blog/how-to-install-ruby-on-windows


```bash
ruby -v
gem -v
gem install bundler
```

### install ms.access driver
https://www.microsoft.com/en-us/download/details.aspx?id=13255

### set ubuntu as root

vi /etc/sudoers

## Install server

### install RVM

```
https://rvm.io/rvm/install
```

### install ruby

```shell
rvm install 3.1.2
rvm install 3.1.2 --with-openssl-dir=$(which openssl) # may be you need openssl
```

### install libs

```shell
sudo apt install nginx redis libvips imagemagick
```

#### install postgres

```shell
sudo apt install libpq-dev postgresql postgresql-contrib -y
sudo systemctl status postgresql
```

#### update postgres password

```
sudo -u postgres psql
\password postgres
```

### postgres peer authentication

```shell
sudo vi /etc/postgresql/14/main/pg_hba.conf

# or

sudo vi /var/lib/pgsql/data/pg_hba.conf

# change line
local   all             postgres                                peer

# to
local   all             postgres                                md5

# restart
sudo systemctl restart postgresql
```

### install node

```shell
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
nvm install 16.14.0 or nvm install node

sudo rm -rf /usr/bin/node
sudo ln -s $(which node) /usr/bin/
sudo rm -rf /usr/bin/npm
sudo ln -s $(which npm) /usr/bin/
```

#### install yarn

```shell
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt install yarn
sudo curl –compressed -o- -L https://yarnpkg.com/install.sh | bash
sudo rm -rf /usr/bin/yarn
sudo ln -s $(which yarn) /usr/bin/
```

### create log dir

```shell
mkdir -p /home/ubuntu/apps/vanct/shared/tmp/sockets/
mkdir -p /home/ubuntu/apps/vanct/shared/tmp/pids/
mkdir -p /home/ubuntu/apps/vanct/shared/tmp/cache/
```

### change nginx user

```shell
sudo vi /etc/nginx/nginx.conf

# change line
user www-data;

# to
user ubuntu;
```

### nginx site config

create new config file

```shell
sudo vi /etc/nginx/sites-enabled/vanct
```

Enter config below:


```shell
upstream puma {
  server unix:///home/ubuntu/apps/vanct/shared/tmp/sockets/vanct-puma.sock;
}

server {
  listen       443 ssl;
  server_name  vanct.vn;

  ssl_certificate      /etc/nginx/ssl/nginx-selfsigned.crt;
  ssl_certificate_key  /etc/nginx/ssl/nginx-selfsigned.key;

  root /home/ubuntu/apps/vanct/current/public;
  access_log /home/ubuntu/logs/nginx.access.log;
  error_log /home/ubuntu/logs/nginx.error.log info;

  location ~* ^assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  try_files $uri/index.html $uri @puma;

  location @puma {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host vanct.vn;
    proxy_set_header X-Forwarded-Proto https;
    proxy_redirect off;
    proxy_pass http://puma;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 4G;
  keepalive_timeout 70;
}

server {
  listen 80;
  listen [::]:80;

  root /home/ubuntu/apps/vanct/current/public;
  access_log /home/ubuntu/logs/nginx.access.log;
  error_log /home/ubuntu/logs/nginx.error.log info;

  server_name 45.251.115.48 vanct.vn www.vanct.vn;

  location ~* ^assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  try_files $uri/index.html $uri @puma;

  location @puma {
    proxy_set_header Host $host;
    proxy_redirect off;
    proxy_pass http://puma;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 4G;
  keepalive_timeout 70;
}
```

### generate puma config

```shell
cap staging puma:config # generate /home/ubuntu/apps/vanct/shared/puma.rb
```

#### create puma service


```shell
sudo vi /etc/systemd/system/puma_vanct_staging.service
```

enter content below:

```shell
[Unit]
Description=Puma HTTP Server for vanct (staging)
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/apps/vanct/current
EnvironmentFile=/etc/environment
# Support older bundler versions where file descriptors weren't kept
# See https://github.com/rubygems/rubygems/issues/3254
ExecStart=/home/ubuntu/.rvm/bin/rvm default do bundle exec puma -C /home/ubuntu/apps/vanct/shared/puma.rb
ExecReload=/bin/kill -USR1 $MAINPID
StandardOutput=append:/home/ubuntu/logs/puma.access.log
StandardError=append:/home/ubuntu/logs/puma.error.log

Restart=always
RestartSec=1

SyslogIdentifier=puma

[Install]
WantedBy=multi-user.target
```

#### upgrade redis

https://redis.io/docs/install/install-redis/install-redis-on-linux/

```shell
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install redis
```

### helper

https://linuxhandbook.com/sudo-unable-resolve-host/



```shell
bundle exec rake zeitwerk:check


sudo systemctl daemon-reload
sudo /bin/systemctl status puma_vanct_staging
sudo systemctl restart puma_vanct_staging

sudo chown ubuntu:ubuntu -R /home/ubuntu/apps/vanct/current/log
sudo chown ubuntu:ubuntu -R /home/ubuntu/apps/vanct/shared/
sudo chown ubuntu:ubuntu -R /home/ubuntu/logs/

sudo systemctl restart nginx
sudo systemctl status nginx
sudo service nginx configtest

sudo vi /etc/systemd/system/puma_vanct_staging.service

sudo vi /etc/nginx/sites-enabled/vanct

sudo vi /home/ubuntu/apps/vanct/shared/puma.rb

```