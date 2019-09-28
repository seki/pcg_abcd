require 'opencv'
require 'drb'
require 'open-uri'

class ABCandD
  def initialize
    @template = %w(A B C).map {|a| [a, OpenCV::IplImage.load("/data/#{a}.png")]}
  end

  def zap(img_or_uri)
    if String === img_or_uri
      img = load_img(img_or_uri)
    else
      img = img_or_uri
    end

    w, h = img.size.width, img.size.height
    # raise "Invalid image size: #{w}x#{h}" unless [748, 1044] == [w, h]

    result = @template.map { |pair|
      [img.match_template(pair[1]).min_max_loc[0], pair[0]]
    }.sort_by {|ary| ary.first}
    result[0] # + [img.size.width, img.size.height]
  end

  def load_img(uri)
    data = URI.open(uri).read
    OpenCV::IplImage.decode(data)
  end
end
