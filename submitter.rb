class Submitter

   attr_accessor :photos
   
   def initialize(slides)
      @slides = slides
   end

   def save! file_path, show=true
      lines = ([@slides.length] + @slides.map{|slide| slide.map(&:id) }).join("\n")
      puts lines if show
      File.write(File.join("./output/", file_path), lines)
   end

end