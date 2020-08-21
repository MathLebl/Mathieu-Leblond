class UsersController < ApplicationController
  before_action :find_user, only: [ :show ]
  def show
    @experiences = Experience.where(user_id: @user.id)
    @experiences.map do |exp|
      @experience = exp
    end
    @xp_descriptions = XpDescription.where(experience_id: @experience.id)
    # @experience = Experience.find(params[:id])
    # @experiences.each do |exp|
    #   @xp_descriptions = exp.xp_descriptions
    # end
    # @xp_descriptions.each do |descro|
    #   @xp_items = descro.xp_items
    # end

    # @xp_items = XpItem.where(xp_description_id: @xp_description.id)
    # @xp_items.each do |xp_item|
    #   @xp_item = xp_item
    # end
    @educations = Education.where(user_id: @user.id)
    @skills = Skill.where(user_id: @user.id)
    @realisations = Realisation.where(user_id: @user.id)

  end
end

private

  def find_user
    @user = User.find(params[:id])
  end
