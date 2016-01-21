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

本人会不断完善[Wiki](https://github.com/gazeldx/meidebook/wiki)
