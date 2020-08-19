class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :title
      t.string :category
      t.integer :range
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
