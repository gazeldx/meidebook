# 美德公益传书活动
[活动详情](http://meidebook.com/about)

# 安装本项目
采用[Sinatra](www.sinatrarb.com)架构搭建本项目，数据库操作用[Sequel](http://sequel.jeremyevans.net/)。

## 安装Ruby
### 安装[rbenv](https://github.com/rbenv/rbenv) 
相比RVM，我更喜欢rbenv。RVM中我想要的功能，rbenv都有。用了rbenv，你会发现一些RVM的不便之处。

### 安装[rbenv-gemset](https://github.com/jf/rbenv-gemset)

## 安装其它软件
[ImageMagick](http://www.imagemagick.org/) 用于图片处理

## 安装本程序
```bash
$ git clone git@github.com:gazeldx/meidebook.git
$ cd /path/to/meidebook
$ gem install bundler
$ bundle install
$ sequel -m db/migrations sqlite://db/book_development.db -E # 创建数据库
$ puma # 启动项目，这时可以访问 http://localhost:9292/ 了
```

## 安装Nginx并运行程序在80端口
```bash
# 先启动meidebook程序。注意下句中的-w后的值是根据cpu核数设置的一个值，为了充分利用多核，可以将它设置为接近cpu的核数；而且不能加端口号，因为端口号是由nginx配置，通过unix:///var/run/meidebook.sock来关联到程序的。
$ bundle exec puma -t 8:32 -w 10 --preload -e production -d -b unix:///var/run/meidebook.sock --pidfile /var/run/meidebook.pid
$ touch /etc/yum.repos.d/nginx.repo #按照 http://wiki.nginx.org/Install 把nginx.repo的内容拷贝进去。
$ yum install nginx
$ vi /etc/nginx/nginx.conf
* 设置 user  root;
* 加gzip压缩选项
    gzip              on;
    gzip_comp_level   8;
    gzip_min_length   1280;
    gzip_buffers      16 8k;
    gzip_types        text/plain text/html text/css application/json application/javascript application/x-javascript text/javascript text/xml application/xml application/rss+xml application/atom+xml application/rdf+xml;
    gzip_vary         on;
$ cd /etc/nginx/conf.d/
$ mv default.conf default.conf_bak
$ cp /srv/uc/meidebook/deploy/meidebook_nginx.conf meidebook.conf
* 设置一下meidebook.conf中的listen和server_name
$ killall -HUP nginx # 无缝重启Nginx（对于修改了Nginx配置的时候很有用）
或者 $ /etc/init.d/nginx restart（不建议使用）
```

* 本人会不断完善[Wiki](https://github.com/gazeldx/meidebook/wiki)
