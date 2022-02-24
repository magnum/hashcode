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