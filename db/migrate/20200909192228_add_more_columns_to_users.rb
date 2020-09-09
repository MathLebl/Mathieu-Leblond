class AddMoreColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :lkd, :string
    add_column :users, :insta, :string
    add_column :users, :ghub, :string
  end
end
