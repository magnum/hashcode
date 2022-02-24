
class Parser
   attr :simulation 

   SEPARATOR = " "

   def initialize
      @data = []
   end


   def purge_output_dir()
      path = "./output/"
      Dir.foreach(File.join(path)) do |f|
         File.delete(File.join(path, f)) if f != '.' && f != '..'
      end
   end


   def create_output_archive
      `tar cvzf output/submission_$(date +"%Y%m%d%H%M%S").tar.gz --exclude .DS_Store --exclude .git --exclude "*.txt" --exclude="./output/*" ./`
   end


   def run(filename, limit=nil)
      input_file_path = File.join("./", filename)
      puts "loading file #{input_file_path}"
      File.open(input_file_path).read.each_line.with_index do |line, index|
         @data << line.strip
         values = line.split " "
         #todo
         puts line
      end

      output_file_path = input_file_path.gsub File.extname(input_file_path), "_submitted_#{Time.now.to_i}#{File.extname(input_file_path)}"
      lines = @data.join("\n")

      purge_output_dir
      File.write(File.join("./output/", output_file_path), lines)
      create_output_archive
   end

end
