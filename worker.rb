class Worker

   attr_accessor :photos
   attr_accessor :slides 
   
   def initialize(photos)
      @photos = photos
      @slides = []
   end

   def perform!
      puts "mumble, mumble..."
      photos_sorted = @photos.shuffle #.sort! { |a, b|  a.flavour <=> b.flavour }
      photos_sorted.each do |photo|
         @slides << [photo]
      end
   end

end