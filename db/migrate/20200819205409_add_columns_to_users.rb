class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :address, :string
    add_column :users, :last_name, :string
    add_column :users, :mail, :string
    add_column :users, :phone, :string
    add_column :users, :description, :text
    add_column :users, :birthdate, :date
  end
end
