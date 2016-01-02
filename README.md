## 美德公益传书活动
[活动详情](http://www.jianshu.com/p/5514fe76cff4)

## 安装本项目
采用[Sinatra](www.sinatrarb.com)架构搭建本项目，数据库操作用[Sequel](http://sequel.jeremyevans.net/)。

```bash
$ cd /path/to/meidebook
$ bundle install
$ sequel -m db/migrations sqlite://db/book_development.db -E # 创建数据库
$ puma # 启动项目，这时可以访问 http://localhost:9292/ 了
```

## TODOs
* 在网站中加入活动说明
* 为每个图书加入一个验证码(防止搜索Engine等)



