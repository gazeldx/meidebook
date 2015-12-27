Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id
      Integer :user_id
      String :body, null: false
      String :title
      Time :created_at
      Time :updated_at
      index :user_id
    end
  end
end