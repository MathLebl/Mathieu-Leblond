class CreateEducations < ActiveRecord::Migration[6.0]
  def change
    create_table :educations do |t|
      t.string :institution
      t.string :title
      t.date :start
      t.date :end
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
