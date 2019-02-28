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
      photos_sorted = @photos.sort! { |a, b|  a.flavour <=> b.flavour }
      photos_sorted.each_with_index do |photo, index|
         slide = Slide.new index, [photo]
         @slides << slide
      end
   end

end