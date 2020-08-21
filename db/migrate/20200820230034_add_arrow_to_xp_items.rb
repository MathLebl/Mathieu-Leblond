class AddArrowToXpItems < ActiveRecord::Migration[6.0]
  def change
    add_column :xp_items, :arrow, :string
  end
end
