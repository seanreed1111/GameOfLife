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
		new_world = World.new
		c10 =new_world.new_cell(1,0)
		c20 = new_world.new_cell(2,0)

	it "should create a new cell" do
		c10.is_a?(Cell).should eq(true)
		new_world.is_a?(World).should eq(true)
	end

	it "should include c10 in the @world instance variable" do
		new_world.world.should include(c10)
		
	end

		it "should include c20 in the @world instance variable" do
		new_world.world.should include(c20)
		
	end
end

describe World, "#num_of_neighbors" do
		new_world = World.new
		c10 = new_world.new_cell(1,0)
		c20 = new_world.new_cell(2,0)
		c11 = new_world.new_cell(1,1)
	it "should compute the correct number of neighbours for (0,0)" do
		new_world.num_of_neighbors(0,0).should eq(2)
	end

	it "should compute the correct number of neighbours for (1,0)" do
		new_world.num_of_neighbors(1,0).should eq(2)
	end

	it "should compute the correct number of neighbours for (2,0)" do
		new_world.num_of_neighbors(2,0).should eq(2)
	end

	it "should compute the correct number of neighbours for (2,1)" do
		new_world.num_of_neighbors(2,1).should eq(3)
	end

	it "should compute the correct number of neighbours for (2,2)" do
		new_world.num_of_neighbors(2,2).should eq(1)
	end

	it "should compute the correct number of neighbours for (3,3)" do
		new_world.num_of_neighbors(3,3).should eq(0)
	end

end



