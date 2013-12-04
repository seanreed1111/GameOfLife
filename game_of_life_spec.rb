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
		c10 =new_world.new_cell(1,0)
		c01 = new_world.new_cell(0,1)
		c12 = new_world.new_cell(1,2)
		c22 = new_world.new_cell(2,2)

	it "should compute the correct number of neighbours for (0,0)" do
		new_world.num_of_neighbors(0,0).should eq(2)
	end

	it "should compute the correct number of neighbours for (1,0)" do
		new_world.num_of_neighbors(1,0).should eq(1)
	end

	it "should compute the correct number of neighbours for (1,1)" do
		puts "new_world.world is #{new_world.world}"
		new_world.num_of_neighbors(1,1).should eq(4)
	end

	it "should compute the correct number of neighbours for (2,0)" do
		new_world.num_of_neighbors(2,0).should eq(1)
	end

	it "should compute the correct number of neighbours for (2,1)" do
		new_world.num_of_neighbors(2,1).should eq(3)
	end

	it "should compute the correct number of neighbours for (2,2)" do
		new_world.num_of_neighbors(2,2).should eq(1)
	end

	it "should compute the correct number of neighbours for (3,3)" do
		new_world.num_of_neighbors(3,3).should eq(1)
	end

		it "should compute the correct number of neighbours for (4,4)" do
		new_world.num_of_neighbors(4,4).should eq(0)
	end

end

describe World, "#alive?" do
	new_world = World.new
	c203_2 = new_world.new_cell(-203,2)
	c2_1000 = new_world.new_cell(2,1000)

	it "should return true for cell created at(-203,2)" do
		new_world.alive?(-203,2).should eq(true)
	end

	it "should return true for cell created at(2,1000)" do
		new_world.alive?(2,1000).should eq(true)
	end

	it "should return false for an arbitrary space at (3,2)" do
		new_world.alive?(3,2).should eq(false)
	end

	it "should return false for an arbitrary space at (34,24)" do
		new_world.alive?(34,24).should eq(false)
	end

end


describe World, "#set_bounds" do
	new_world = World.new
	c10 =new_world.new_cell(1,0)
	c05 = new_world.new_cell(0,5)

	it "should return the proper value for cells at c10 and c05" do
		new_world.set_bounds
		new_world.bounds.should eq([-1,2,-1,6])
	end

	it "should return the proper value for cells at c(1,0), c(0,5), and c(43,-22)" do
		c43_22 = new_world.new_cell(43,-22)
		new_world.set_bounds
		new_world.bounds.should eq([-1,44,-23,6])
	end

end

describe World, "#reincarnation_locations" do

	new_world = World.new
	c10 =new_world.new_cell(1,0)
	c01 = new_world.new_cell(0,1)
	new_world.set_bounds

	it "should return an empty array if there are not exactly 3 neighbours" do
		new_world.reincarnation_locations.should eq([])
	end

	it "should return only one location if there is one square with exactly 3 neighbours" do
		c12 = new_world.new_cell(1,2)
		new_world.set_bounds
		new_world.reincarnation_locations.should include([1,1])
	end

	it "should return multiple location if there is more than one square with exactly 3 neighbours" do
		c12 = new_world.new_cell(1,2)
		c22 = new_world.new_cell(2,2)
		c23 = new_world.new_cell(2,3)
		new_world.set_bounds
		new_world.reincarnation_locations.should eq([[1,2],[1,3],[2,1]])
		
	end


end

