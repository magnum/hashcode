class Submitter

   attr_accessor :photos
   
   def initialize(data)
      @data = data
   end

   def save!(file_path, show=false)
      lines = @data.join("\n")
      puts lines if show
      File.write(File.join("./output/", file_path), lines)
   end

end