Sequel.migration do
  change do
    create_table(:books) do
      primary_key :id
      String :code, null: false
      Time :created_at
      Time :updated_at
      index :code
    end
  end
end