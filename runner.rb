require './parser.rb'

object = Parser.new
filename = ARGV[0]
limit = ARGV[1] || nil
object.run filename, limit