class EpisodesController < ApplicationController
skip_before_action :authenticate_user!
  def index
    @index = false
    @episodes = Episode.all
  end

  def new
    @episode = Episode.new
  end

  def create
    @episode = Episode.new(episode_params)
    @episode.save!
  end

  def scrape_samec
    ScrapeSamec.call
    redirect_to episodes_index_path

  end


private

  def episode_params
    params.require(:episode).permit(:title, :url, :embed)
  end
end
