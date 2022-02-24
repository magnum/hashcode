class Simulation
   attr :duration
   attr :intersections_number
   attr :streets
   attr :cars
   attr :points
   attr :intersections
   def initialize(duration, intersections_number, points)
      @duration = duration.to_i
      @intersections_number = intersections_number.to_i
      @streets = []
      @intersections = []
      @cars = []
      @points = points.to_i
   end
end

class Street
   attr :i1
   attr :i2
   attr :name
   attr :length
   def initialize(i1, i2, name, length)
      @i1 = i1
      @i2 = i2
      @name = name
      @length = length.to_i
   end
end


class Car 
   attr :id
   attr :path
   attr :from
   attr :to
   def initialize(id, path)
      @id = id
      @path = path
      @from = path[0]
      @to = path[1]
   end

   def path_length 
      path[1..-1].inject(0){|sum, s| sum += s.length }
   end

end

class Intersection
   attr :id
   attr :status
   attr :cars
   def initialize(id, status)
      @id = id
      @status = status
      @cars = []
   end
end

class Parser
   attr :simulation 

   SEPARATOR = " "

   def initialize
      @data = []
   end

   def run(filename, limit=nil)
      input_file_path = File.join("./", filename)
      puts "loading file #{input_file_path}"
      streets_number = 0
      File.open(input_file_path).read.each_line.with_index do |line, index|
         @data << line.strip
         values = line.split " "
         if index == 0
            @simulation = Simulation.new values[0], values[1], values[4]
            streets_number = values[2].to_i
            cars_number = values[3]
         end
         if index > 0 && index < streets_number+1
            i1 = values[0]
            i2 = values[1]
            @simulation.streets << Street.new(i1, i2, values[2], values[3])
            values[0..1].each do |id|
               @simulation.intersections << Intersection.new(id, :red) unless @simulation.intersections.find{|i| i.id == id}
            end
         end
         if index >= streets_number+1
            @simulation.cars << Car.new(@simulation.cars.length, values[1..-1].map{|name| @simulation.streets.find{|s| s.name==name}})
         end
         
      end

      @simulation.cars.each do |car|
         initial_street = @simulation.streets.find{|s| s.name == car.path.first.name}
         final_intersection = @simulation.intersections.find{|i| i.id == initial_street.i2}
         final_intersection.cars << car
      end

      pp @simulation
      @simulation.intersections.each do |i|
         puts "i: #{i.id}, cars: #{i.cars.map(&:id)}"
      end

      #simulation
      cars_sorted = @simulation.cars.sort_by(&:path_length)#.map(&:id)

      # @simulation.duration.times do |t|
      #    #car_first = cars_sorted.first
      #    #puts car_first.to.name
      #    @simulation.intersections.each do |i|
      #       i.carst.first.intersesections
      #    end
      # end

      output_file_path = input_file_path.gsub File.extname(input_file_path), "_submitted_#{Time.now.to_i}#{File.extname(input_file_path)}"
      lines = @data.join("\n")
      #File.write(File.join("./output/", output_file_path), lines)

   end

end
