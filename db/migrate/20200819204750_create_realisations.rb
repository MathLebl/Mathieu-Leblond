class CreateRealisations < ActiveRecord::Migration[6.0]
  def change
    create_table :realisations do |t|
      t.string :title
      t.text :description
      t.string :category
      t.string :link
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
