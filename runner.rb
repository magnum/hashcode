require 'pry'

def create_output_archive
  `tar cvzf output/submission_$(date +"%Y%m%d%H%M%S").tar.gz --exclude .DS_Store --exclude .git --exclude "*.txt" --exclude="./output/*" ./`
end


def purge_output_dir()
  path = "./output/"
  Dir.foreach(File.join(path)) do |f|
      File.delete(File.join(path, f)) if f != '.' && f != '..'
  end
end

[
  "a_an_example.in.txt",
  "b_better_start_small.in.txt",
].each do |filename|
  SEP = " "
  @data = []
  input_file_path = File.join("./", filename)
  puts "loading file #{input_file_path}"
  projects_count, people_count = 0
  lines = []
  people = []
  File.open(input_file_path).read.each_line.with_index do |line, index|
      @data << line.strip
      values = line.split " "
      projects_count, people_count = line.split(SEP).map(&:to_i) if index == 0
      lines << line
  end
  people = []
  projects = []
  object_index = 1
  lines.each_with_index do |line, index|
      if index > 0
        if index == object_index 
            if people.length < people_count
              name, skills_count  = line.split(SEP).map.with_index{|value, index| index == 0 ? value : value.to_i}
              people.send("<<", {
                  name: name,
                  skills: lines[(index+1)..(index+skills_count)].map{|s| s.split(" ")},
              })
              object_index += skills_count+1
            else 
              name, duration, score, limit, skills_count = line.split(SEP).map.with_index{|value, index| index == 0 ? value : value.to_i}
              binding.pry
              projects.send("<<", {
                  name: name,
                  duration: duration,
                  score: score,
                  limit: limit,
                  skills: lines[(index+1)..(index+skills_count)].map{|s| name, level = s.split(SEP); {name: name, level: level.to_i}},
              })
              object_index += skills_count+1
            end
        end
      end
  end

  puts "projects_count: #{projects_count}, people_count: #{people_count}"
  #pp people
  result = {
      projects: []
  } 
  projects.each do |project|
      contributors = []
      result[:projects] << {
        name: project[:name], 
        contributors: people.map{|p| p[:name]},
      }
  end
  pp result

  purge_output_dir
  output_file_path = File.join "./output", (input_file_path.gsub File.extname(input_file_path), "_output.#{File.extname(input_file_path)}")
  open(output_file_path, 'w') do |f| 
      f << "#{projects.length}\n"
      result[:projects].each do |project|
        f << "#{project[:name]}\n"
        f << "#{project[:contributors].join(SEP)}\n"
      end
  end
end


