ActiveAdmin.register Experience do
  ActiveAdmin.register XpDescription do
    belongs_to :experience
  end
  permit_params :entreprise, :start, :end, :role, :user_id, xp_description_attributes: [:id, :text, :item, :_destroy]
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  #
  # or
  #
  # permit_params do
  #   permitted = [:entreprise, :start, :end, :role, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
