ActiveAdmin.register Experience do
  ActiveAdmin.register XpDescription do
    belongs_to :experience
  end
    ActiveAdmin.register XpItem do
      belongs_to :xp_description
      belongs_to :experience
    end
  permit_params :entreprise, :start, :end, :role, :user_id,
                xp_descriptions_attributes: [:id, :text, :_destroy],
                xp_items_attributes: [:id, :item, :arrow, :_destroy, :xp_description_id]

  form do |f|
    f.inputs do
      f.input :user_id, label: 'User', as: :select, collection: User.all.map { |u| ["#{u.first_name}", u.id] }
      f.input :role
      f.input :entreprise
      f.inputs do
        f.has_many :xp_descriptions, allow_destroy: true do |t|
          t.input :text
          t.has_many :xp_items, through: :xp_descriptions, allow_destroy: true do |d|
            d.input :arrow
          end
        end
      end
      f.input :start
      f.input :end
      f.actions
    end
  end
end
