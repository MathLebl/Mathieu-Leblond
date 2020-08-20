ActiveAdmin.register Experience do
  ActiveAdmin.register XpDescription do
    belongs_to :experience
  end
  permit_params :entreprise, :start, :end, :role, :user_id, xp_description_attributes: [:id, :text, :item, :_destroy]

  form do |f|
    f.inputs do
      f.input :user_id, :label => 'User', :as => :select, :collection => User.all.map{|u| ["#{u.first_name}", u.id]}
      f.input :role
      f.input :entreprise
      f.inputs do
        f.has_many :xp_description, allow_destroy: true do |t|
          t.input :text
        end
      end
      f.inputs do
        f.has_many :xp_description, allow_destroy: true do |t|
          t.input :item
        end
      end
      f.input :start
      f.input :end
      f.actions
    end
  end
end
