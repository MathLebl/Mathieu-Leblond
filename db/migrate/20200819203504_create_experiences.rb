class CreateExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :experiences do |t|
      t.string :entreprise
      t.date :start
      t.date :end
      t.string :role
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
