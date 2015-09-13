Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = case Padrino.env
  when :development then Sequel.connect("sqlite:///" + Padrino.root('db', "xinxue_development.db"), :loggers => [logger])
  when :production  then Sequel.connect("sqlite:///" + Padrino.root('db', "xinxue_production.db"),  :loggers => [logger])
  when :test        then Sequel.connect("sqlite:///" + Padrino.root('db', "xinxue_test.db"),        :loggers => [logger])
end
