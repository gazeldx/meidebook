[美德公益读书活动](http://meidebook.com/about)

# deploy目录说明
和发布有关，如服务器如何配置等。

## 安装Nginx并运行程序在80端口
```bash
# 先启动meidebook程序。注意下句中的-w后的值是根据cpu核数设置的一个值，为了充分利用多核，可以将它设置为接近cpu的核数；而且不能加端口号，因为端口号是由nginx配置，通过unix:///var/run/meidebook.sock来关联到程序的。
$ bundle exec puma -t 8:32 -w 1 --preload -e production -d -b unix:///var/run/meidebook.sock --pidfile /var/run/meidebook.pid
按照 http://wiki.nginx.org/Install 安装Nginx，下文以centOS为例。
$ touch /etc/yum.repos.d/nginx.repo
按照[Nginx wiki](http://wiki.nginx.org/Install)所述，把nginx.repo的内容拷贝进去。
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
$ cp /srv/meidebook/deploy/meidebook_nginx.conf meidebook.conf
* 设置一下meidebook.conf中的listen和server_name
$ killall -HUP nginx # 无缝重启Nginx（对于修改了Nginx配置的时候很有用）
或者 $ /etc/init.d/nginx restart（不建议使用）
```

## 日常更新
```bash
$ cd /path/to/meidebook
$ git pull origin master # 下载最新代码
$ kill -s SIGUSR2 `cat /var/run/meidebook.pid` # 无缝重启Web
```

  其它使用帮助见[Wiki](https://github.com/gazeldx/meidebook/wiki)
