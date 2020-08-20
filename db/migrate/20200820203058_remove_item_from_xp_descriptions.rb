class RemoveItemFromXpDescriptions < ActiveRecord::Migration[6.0]
  def change
    remove_column :xp_descriptions, :item, :string
  end
end
