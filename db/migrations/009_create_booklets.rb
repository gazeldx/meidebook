Sequel.migration do
  change do
    # 图书详细信息。
    create_table(:booklets) do
      Bignum :id, primary_key: true # 书的ISBN
      String :douban_message, text: true # 查询豆瓣API所返回的json
      Time :created_at
      Time :updated_at
    end
  end
end