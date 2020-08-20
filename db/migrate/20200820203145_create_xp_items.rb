class CreateXpItems < ActiveRecord::Migration[6.0]
  def change
    create_table :xp_items do |t|
      t.string :item
      t.references :xp_description, null: false, foreign_key: true

      t.timestamps
    end
  end
end
