Sequel.migration do
  change do
    add_column :books, :name, String
    add_column :books, :isbn, String
    add_index :books, :isbn
  end
end