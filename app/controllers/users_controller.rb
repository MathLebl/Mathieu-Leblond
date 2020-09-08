class UsersController < ApplicationController
  before_action :find_user, only: [ :show ]
  def show
    @experiences = @user.experiences
    @xp_descriptions = @experiences.map(&:xp_descriptions)
    @xp_descriptions.map do |description|
      @xp_description = description
      @xp_items = @xp_description.map(&:xp_items)
    end
    @educations = Education.where(user_id: @user.id)
    @skills = Skill.where(user_id: @user.id)
    @realisations = Realisation.where(user_id: @user.id)

  end
end

private

  def find_user
    @user = User.find(params[:id])
  end

