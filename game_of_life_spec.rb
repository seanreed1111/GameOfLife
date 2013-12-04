# The universe of the Game of Life is an infinite two-dimensional orthogonal grid of square cells, 
# each of which is in one of two possible states, alive or dead. 
# Every cell interacts with its eight neighbours, which are the cells that are horizontally, vertically,
#  or diagonally adjacent. At each step in time, the following transitions occur:

#  Rule1   Any live cell with fewer than two live neighbours dies
#  Rule2   Any live cell with two or three live neighbours lives on to the next generation.
#  Rule3   Any live cell with more than three live neighbours dies
#  Rule4   Any dead cell with exactly three live neighbours becomes a live cell

# The initial pattern constitutes the seed of the system. 
# The first generation is created by applying the above rules 
#simultaneously to every cell in the seed—births and deaths occur simultaneously, 

# and the discrete moment at which this happens is sometimes called a tick 
# (in other words, each generation is a pure function of the preceding one). 
# The rules continue to be applied repeatedly to create further generations.

require './cell'
require './world'

describe "testing world#new_cell" do
	it "should create a new cell" do
	end

	it "should put the new cell in the world array variable" do
	end
end

# describe "testing rule numbers 1-3" do
# 		new_world = World.new
# 		c00 = new_world.new_cell(0,0)
# 		c10 = new_world.new_cell(1,0)
# 	it 'should be able to count its neighbors'do
# 		c00.neighbors.should eq(1)
# 	end

# 	it 'should satisfy Any live cell with two or three live neighbours lives on'  do
# 		true
# 	end
# end


