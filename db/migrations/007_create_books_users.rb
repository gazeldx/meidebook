Sequel.migration do
  change do
    # 用户和书的认领关系表
    create_table(:books_users) do
      primary_key :id
      Integer :book_id
      Integer :user_id
      Time :created_at
      index :book_id
      index :user_id
    end
  end
end