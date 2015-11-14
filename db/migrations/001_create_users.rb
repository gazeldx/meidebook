Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :username, null: false
      String :nickname
      String :password, null: false
      String :password_hint
      String :email
    end
  end
end