Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :login_name, null: false
      String :password, null: false
      String :nickname, null: false
      String :email
      DateTime :created_at
    end
  end

  down do
    drop_table(:users)
  end
end
