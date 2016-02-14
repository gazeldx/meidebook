Sequel.migration do
  change do
    add_column :books, :user_id, Integer
    add_index :books, :user_id
  end
end