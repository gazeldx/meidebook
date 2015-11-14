## 开发本项目的全过程笔记
采用[Sinatra](www.sinatrarb.com)架构搭建本项目，数据库操作用[Sequel](http://sequel.jeremyevans.net/)。

```bash
$ cd /path/to/xinxue
$ bundle install
$ sequel -m db/migrations sqlite://db/xinxue_development.db -E # 创建数据库
$ ruby xinxue.rb # 启动项目，这时可以访问 http://localhost:4567/ 了
```

### 数据库相关
采用[padrino](http://www.padrinorb.com/guides)默认使用的SQLite数据库

`$ padrino g migration CreateUsers`

编辑`db/migrate/001_create_users.rb`参考：[sequel schema modification](http://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html) 和 [sequel migration](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html)

`$ rake sq:migrate:up`参考：[padrino rake-tasks](http://www.padrinorb.com/guides/rake-tasks)

之后用SQLite3自带的命令行进入 db/xinxue_development.db 查看数据

`$ sqlite3 xinxue_development.db`

### 生成admin
请参考：[generating-the-admin-section](http://www.padrinorb.com/guides/basic-projects#generating-the-admin-section)
```bash
$ padrino g admin
$ padrino rake sq:migrate
$ padrino rake seed
```





