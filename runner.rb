require './parser.rb'

parser = Parser.new

# filename = ARGV[0]
# limit = ARGV[1] || nil
# parser.run filename, limit

[
  "test.txt",
].each do |filename|
  parser.run filename
end
exec('tar cvzf output/submission_$(date +"%Y%m%d%H%M%S").tar.gz  --exclude .git --exclude "*.txt" --exclude="./output/*" ./')

