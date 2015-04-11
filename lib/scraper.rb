require "open-uri"
require 'fileutils'

class Scraper
  IMAGE_PATH = '../../app/assets/images/cards/medium'
  BASE_URL = 'http://wow.zamimg.com/images/hearthstone/cards/enus/medium/'
  
  def get_medium_card_image(image_name)
    image_folder = File.expand_path(IMAGE_PATH, __FILE__)
    puts image_folder
    unless File.directory?(image_folder)
      FileUtils.mkdir_p(image_folder)
    end
    File.write("#{image_folder}/#{image_name}.png", open("#{BASE_URL}#{image_name}.png").read)
  end
end

if __FILE__ == $0
  require 'json'
  scraper = Scraper.new
  json = JSON.parse(File.read(File.expand_path('../../db/cards.json', __FILE__)))
  json.each do |c|
    puts "get #{c['name']}"
    scraper.get_medium_card_image(c['image'])
  end
end