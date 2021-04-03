class CreateEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :episodes do |t|
      t.string :title
      t.string :url
      t.string :embed

      t.timestamps
    end
  end
end
