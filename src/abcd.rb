require 'opencv'
require 'drb'
require 'open-uri'

class ABCandD
  def initialize
    @template = %w(A B C).map {|a| [a, OpenCV::IplImage.load("/data/#{a}.png")]}
  end

  def zap(uri)
    img = load_img(uri)
    result = @template.map { |pair|
      [img.match_template(pair[1]).min_max_loc[0], pair[0]]
    }.sort_by {|ary| ary.first}
    result[0]
  end

  def classify(uri)
    score, klass = zap(uri)
    raise "Error too large #{score}" if score > 5000000.0
    klass
  end

  def load_img(uri)
    data = URI.open(uri).read
    OpenCV::IplImage.decode(data)
  end
end

if __FILE__ == $0
  if uri = ARGV.shift
    DRb.start_service(uri, ABCandD.new)
    DRb.thread.join
  end
end