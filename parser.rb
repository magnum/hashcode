require './photo.rb'
require './submitter.rb'

class Parser
   attr_accessor :photos

   SEPARATOR = " "

   def initialize
      @books_number = 0
      @books_scores = []
      @libraries = []
      @libraries_signed_up = []
      @libraries_number = 0
      @output = []
      @how_many_days = 0
   end

   def run(args)
      input_file_path = File.join("./", args[0])
      puts "loading file #{input_file_path}"
      limit = args[1] || nil
      library_id = 0
      File.open(input_file_path).read.each_line.with_index do |line, index|
         #break if index > 5
         if(index==0)
            @books_number, @libraries_number, @how_many_days = line.split(SEPARATOR).map(&:to_i)
         elsif(index==1)
            @books_scores = line.split(SEPARATOR)
         else
            #library
            library = {}
            if index.even?
               library_parts = line.split(SEPARATOR)
               next if library_parts.length < 2
               library[:id] = library_id
               library[:books_number] = library_parts[0].to_i
               library[:signup_days] = library_parts[1].to_i
               library[:books_per_days] = library_parts[2].to_i
               @libraries << library
               library_id +=1
            else 
               current_library = @libraries.last
               current_library[:books] = line.split(SEPARATOR)
               current_library[:books_per_score] = line.split(SEPARATOR).sort_by{ |b| @books_scores[b.to_i] }.reverse
               # library scoring
               current_library[:total_score] = 0
               current_library[:books_per_score].uniq.each do |book_id|
                  current_library[:total_score] += @books_scores[book_id.to_i].to_i
               end

               score = (current_library[:books_per_days] * current_library[:books_number] + current_library[:total_score]) * 1/current_library[:signup_days] 
               puts "score is nil for library at index #{index}" unless score
               current_library[:score] = score
            end
         end
      end

      #output
      days_left = @how_many_days

      @libraries.sort_by {|l| l[:score] }.reverse.each do |library|
         wanted_books_from_library = (days_left + library[:signup_days]) * library[:books_per_days]
         library[:books_to_send] = wanted_books_from_library > library[:books_number] ? library[:books_number] : wanted_books_from_library
         @libraries_signed_up << library
         days_left -= library[:signup_days]
         break if days_left <= 0
      end
      
      @output = [@libraries_signed_up.count]
      @libraries_signed_up.each_with_index do |library, index|
         @output << [library[:id], library[:books_to_send]].join(SEPARATOR) 
         @output << library[:books_per_score].take(library[:books_to_send]).join(SEPARATOR)
      end


      output_file_path = input_file_path.gsub File.extname(input_file_path), "_submitted_#{Time.now.to_i}#{File.extname(input_file_path)}"
      submitter = Submitter.new(@output)
      submitter.save! output_file_path

   end

end
