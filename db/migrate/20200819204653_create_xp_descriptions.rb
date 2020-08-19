class CreateXpDescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :xp_descriptions do |t|
      t.string :item
      t.text :text
      t.references :experience, null: false, foreign_key: true

      t.timestamps
    end
  end
end
