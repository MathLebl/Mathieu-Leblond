class PagesController < ApplicationController
skip_before_action :authenticate_user!, only: :home
  def home
    @index = true
  end
end
