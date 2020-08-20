class UsersController < ApplicationController
  before_action :find_user, only: [ :show ]
  def show
    @experiences = Experience.where(user_id: @user.id)
    @experience = Experience.find(params[:id])
    @xp_descriptions = XpDescription.where(experience_id: @experience.id)
    @xp_description = XpDescription.find(params[:id])
    @xp_items = XpItem.where(xp_description_id: @xp_description.id)
    @educations = Education.where(user_id: @user.id)
    @skills = Skill.where(user_id: @user.id)
    @realisations = Realisation.where(user_id: @user.id)

  end
end

private

  def find_user
    @user = User.find(params[:id])
  end
