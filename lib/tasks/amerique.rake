require 'mechanize'
namespace :amerique do
  desc "Récupère les episodes"
  task get_saec_episodes: :environment do
    # shows = []
    url = "https://www.franceinter.fr/emissions/si-l-amerique-m-etait-contee"
    agent = Mechanize.new
    page = agent.get(url)
    another_page = true
    page_num = 1
    while another_page == true
      shows_blocks = page.search('.card')
      shows_blocks.each do |block|
        if !block.search('.media-visual-replay-button button')[0].nil?
            title = block.search('a.card-text-sub').text.strip
            data_url = block.search('.media-visual-replay-button button')[0].attributes['data-url'].value
            data_uuid = block.search('.media-visual-replay-button button')[0].attributes['data-diffusion-uuid'].value
          Episode.create(title: title, url: data_url , embed: data_uuid)
        end
      end
      if page_num == 6
        another_page = false
      else
        page = agent.get("https://www.franceinter.fr/emissions/si-l-amerique-m-etait-contee?p=#{page_num+1}")
      end
      page_num += 1
    end
  end
end
