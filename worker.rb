require './slide.rb'

class Worker

   attr_accessor :photos
   attr_accessor :slides 
   
   def initialize(photos)
      @photos = photos
      @slides = []
   end

   def perform!
      puts "mumble, mumble..."
      tags = {}
      @photos.each_with_index do |photo|
         photo.tags.each do |tag|
            tags[tag] = [] unless tags[tag]
            tags[tag] << photo.id
         end
      end
      puts tags.select{|key, value| value.length > 1 } #todo, shit! noticed at the end that tags was so different: each tags had only max 2 photos tagged w/ it
   end

end