require 'pry'

class Photo
  
  attr_accessor :string 
  attr_accessor :id
  attr_accessor :orientation
  attr_accessor :tags_number
  attr_accessor :tags
  attr_accessor :flavour

  def initialize(id, string)
    @string = string
    #puts string
    parts = string.split(" ")
    @id = id
    @orientation = parts[0]
    @tags_number = parts[1]
    @tags = parts.length > 2 ? parts[2..parts.length].map(&:strip).sort : []
    @flavour = @tags.join(",")
  end

  def to_s
    "id: #{@id}, orientation: #{@orientation}, tags_number: #{@tags_number}, flavour : #{@flavour} "
  end

  def interest_factor_with(other_photo)
    tags_in_common = @tags & other_photo.tags
    tags_in_1st_not_in_2nd = @tags - tags_in_common
    tags_in_2nd_not_in_1st = other_photo.tags - tags_in_common
    puts "tags_in_common: #{tags_in_common.length}, tags_in_1st_not_in_2nd: #{tags_in_1st_not_in_2nd.length}, tags_in_2nd_not_in_1st: #{tags_in_2nd_not_in_1st.length}"
    factor = [tags_in_common.length, tags_in_1st_not_in_2nd.length, tags_in_2nd_not_in_1st.length].min
  end

end