## 开发本项目的全过程笔记
采用[Sinatra](www.sinatrarb.com)架构搭建本项目，数据库操作用[Sequel](http://sequel.jeremyevans.net/)。

```bash
$ cd /path/to/xinxue
$ bundle install
$ sequel -m db/migrations sqlite://db/xinxue_development.db -E # 创建数据库
$ ruby xinxue.rb # 启动项目，这时可以访问 http://localhost:4567/ 了
```





