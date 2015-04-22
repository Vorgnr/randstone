
  if __FILE__ == $0
    require('mini_magick')
    img_working_dir = File.expand_path('../../app/assets/images/cards', __FILE__)
    destination_dir = "#{img_working_dir}/dest"
    width = '193'
    height = '270'
    w_offset = '4'
    h_offset = '22'

    unless File.directory?(destination_dir)
      FileUtils.mkdir_p(destination_dir)
    end

    Dir.glob("#{img_working_dir}/medium/*.png") do |img_path|
      puts "Cropping #{img_path}"
      img = MiniMagick::Image.open(img_path)
      img.crop("#{width}x#{height}+#{w_offset}+#{h_offset}").write "#{destination_dir}/#{img_path.split('/')[-1]}"
    end
  end