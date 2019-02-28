require 'pry'

class Slide
  
  attr_accessor :index
  attr_accessor :photos

  def initialize(index, photos=[])
    @index = index
    @photos = photos
  end

  def add_photo(photo, index=nil)
    index = @photos.length-1 unless index
    @photos.insert photo, index
  end

  def to_s
    [
      "slide #{@index}",
      @photos.map(&:to_s)
    ].join("\n")
  end


end