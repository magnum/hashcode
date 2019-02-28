require './photo.rb'
require './worker.rb'
require './submitter.rb'

class Parser
   attr_accessor :photos

   def initialize
      @photos = []
   end

   def run(args)
      input_file_path = File.join("./", args[0])
      puts "loading file #{input_file_path}"
      limit = args[1] || nil
      File.open(input_file_path).read.each_line.with_index do |line, index|
         @photos << Photo.new(index-1, line) if index > 0 #skip 1st line
         break if limit && index >= limit.to_i
      end

      worker = Worker.new @photos
      worker.perform!
      worker.slides.each_with_index do |slide, index|
         puts [
            slide.to_s,
            "-"*30,
         ].join("\n")
      end

      output_file_path = input_file_path.gsub File.extname(input_file_path), "_submitted_#{Time.now.to_i}#{File.extname(input_file_path)}"
      submitter = Submitter.new(worker.slides)
      submitter.save! output_file_path

   end
end