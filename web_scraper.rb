require 'open-uri'
require 'nokogiri'

# Feeding Models Galleries URLs
feedlist = File.open('urls')
base_url = 'http://www.babeimpact.com'

# Packaging URLs into galleries URLs array
galleries = []
feedlist.each do |url|
  galleries << url.gsub("\n", '')
end

# Downloading all images from each gallery
downloads = 0
galleries.each do |url|
  gallery = Nokogiri::HTML(open(url))
  anchors = gallery.xpath \
            ("//div[@class='list gallery']/div[@class='item']/a")

  images = []
  anchors.each do |a|
    path = a['href']
    images << "#{base_url}#{path}"
  end

  # Download each individual image from a gallery
  img_counter = 0
  images.each do |url|
    img_page    = Nokogiri::HTML(open(url))
    image       = img_page.xpath("//div[@class='image-wrapper']/a/img")
    img_src     = image[0]['src']
    img_alt     = image[0]['alt']
    img_counter = img_counter + 1
    File.open("#{img_alt} - #{img_counter}.jpg", "w+") do |file|
      # puts Dir.pwd
      # File.join(Dir.pwd, "file.txt")
      # file.write(open(img_src)).read
      # file.write open('http://example.com/your.file').read
      file.write open(img_src).read
      # file.close
    end
  end
  downloads = downloads + img_counter

end

puts "#{downloads} images was successfully downloaded!"
