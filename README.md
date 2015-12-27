## 美德公益传书游戏
游戏详情见：[游戏玩法](http://www.jianshu.com/p/5514fe76cff4)

## 开发本项目的全过程笔记
采用[Sinatra](www.sinatrarb.com)架构搭建本项目，数据库操作用[Sequel](http://sequel.jeremyevans.net/)。

```bash
$ cd /path/to/meidebook
$ bundle install
$ sequel -m db/migrations sqlite://db/book_development.db -E # 创建数据库
$ puma # 启动项目，这时可以访问 http://localhost:9292/ 了
```





