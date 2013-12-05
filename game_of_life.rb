require './universe'
require './cell'

# to "animate" your game of life:

# This is assuming you have an array of arrays:


puts "\e[H"
new_universe = Universe.new
new_universe.go!

1.upto(100) {
	new_universe.print_universe	
	sleep(0.15)
	new_universe.tick!
	new_universe.print_universe

}
puts ""




# array.each do |inner_array|
#   inner_array.each {|x| print "#{x} "}
#   puts
# end

#  puts "\e[H"'
#The escape code to hide that ugly cursor: \e[?25l

