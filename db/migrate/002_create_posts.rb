Sequel.migration do
  up do
    create_table(:posts) do
      primary_key :id
      foreign_key :user_id, :users
      String :title
      String :body, null: false
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:posts)
  end
end
