require './parser.rb'


object = Parser.new

[
  "b_read_on.txt",
  "c_incunabula.txt",
  "d_tough_choices.txt",
  "e_so_many_books.txt",
  "f_libraries_of_the_world.txt",
].each do |filename|
  object.run filename
end
exec('tar cvzf output/submission_$(date +"%Y%m%d%H%M%S").tar.gz  --exclude .git --exclude "*.txt" --exclude="./output/*" ./')

