ActiveAdmin.register XpItem do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :item, :xp_description_id, :arrow
  #
  # or
  #
  # permit_params do
  #   permitted = [:item, :xp_description_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
