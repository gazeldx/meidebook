Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username, null: false
      String :nickname
      String :password, null: false
      String :password_hint
      String :email
      index :username
      index :email
    end

    # 下面的这些列是在之后的migration文件中加入的
    # add_column :users, :domain, String
    # add_column :users, :created_at, Time
    # add_column :users, :updated_at, Time
  end
end