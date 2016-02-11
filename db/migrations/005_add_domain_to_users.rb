Sequel.migration do
  change do
    add_column :users, :domain, String
    add_column :users, :created_at, Time
    add_column :users, :updated_at, Time
  end
end