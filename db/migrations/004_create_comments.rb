# 对书的评论
Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      Integer :book_id
      Integer :user_id
      String :body
      String :photo
      Time :created_at
      Time :updated_at
      index :book_id
    end
  end
end