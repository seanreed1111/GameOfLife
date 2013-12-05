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
require './universe'

describe "testing Universe#new_cell" do
		new_universe = Universe.new
		c10 =new_universe.new_cell(1,0)
		c20 = new_universe.new_cell(2,0)

	it "should create a new cell" do
		c10.is_a?(Cell).should eq(true)
		new_universe.is_a?(Universe).should eq(true)
	end

	it "should include c10 in the @world instance variable" do
		new_universe.world.should include(c10)
		
	end

		it "should include c20 in the @world instance variable" do
		new_universe.world.should include(c20)
		
	end
end

describe Universe, "#neighbors" do
		new_universe = Universe.new
		c10 =new_universe.new_cell(1,0)
		c20 = new_universe.new_cell(2,0)
		c11 = new_universe.new_cell(1,1)
		c12 = new_universe.new_cell(1,2)
		c22 = new_universe.new_cell(2,2)

	it "should compute the correct number of neighbours for (0,0)" do
		new_universe.neighbors(0,0).length.should eq(2)
	end

	it "should compute the correct number of neighbours for (1,0)" do
		new_universe.neighbors(1,0).length.should eq(2)
	end

	it "should compute the correct number of neighbours for (1,1)" do
		puts "new_universe.world is #{new_universe.world}"
		new_universe.neighbors(1,1).length.should eq(4)
	end

	it "should compute the correct number of neighbours for (1,2)" do
		new_universe.neighbors(1,2).length.should eq(2)
	end

	it "should compute the correct number of neighbours for (2,0)" do
		new_universe.neighbors(2,0).length.should eq(2)
	end

	it "should compute the correct number of neighbours for (2,1)" do
		new_universe.neighbors(2,1).length.should eq(5)
	end

	it "should compute the correct number of neighbours for (2,2)" do
		new_universe.neighbors(2,2).length.should eq(2)
	end

	it "should compute the correct number of neighbours for (3,3)" do
		new_universe.neighbors(3,3).length.should eq(1)
	end

		it "should compute the correct number of neighbours for (4,4)" do
		new_universe.neighbors(4,4).length.should eq(0)
	end

end

describe Universe, "#alive?" do
	new_universe = Universe.new
	c203_2 = new_universe.new_cell(-203,2)
	c2_1000 = new_universe.new_cell(2,1000)

	it "should return true for cell created at(-203,2)" do
		new_universe.alive?(-203,2).should eq(true)
	end

	it "should return true for cell created at(2,1000)" do
		new_universe.alive?(2,1000).should eq(true)
	end

	it "should return false for an arbitrary space at (3,2)" do
		new_universe.alive?(3,2).should eq(false)
	end

	it "should return false for an arbitrary space at (34,24)" do
		new_universe.alive?(34,24).should eq(false)
	end

end


describe Universe, "#set_bounds" do
	new_universe = Universe.new
	c10 =new_universe.new_cell(1,0)
	c05 = new_universe.new_cell(0,5)

	it "should return the proper value for cells at c10 and c05" do
		new_universe.set_bounds
		new_universe.bounds.should eq([-1,2,-1,6])
	end

	it "should return the proper value for cells at c(1,0), c(0,5), and c(43,-22)" do
		c43_22 = new_universe.new_cell(43,-22)
		new_universe.set_bounds
		new_universe.bounds.should eq([-1,44,-23,6])
	end

end

describe Universe, "#where_to_reanimate" do

	new_universe = Universe.new
	c10 =new_universe.new_cell(1,0)
	c01 = new_universe.new_cell(0,1)
	new_universe.set_bounds

	it "should return an empty array if there are not exactly 3 neighbours" do
		new_universe.where_to_reanimate.should eq([])
	end

	it "should return only one location if there is one square with exactly 3 neighbours" do
		c12 = new_universe.new_cell(1,2)
		new_universe.set_bounds
		new_universe.where_to_reanimate.should include([1,1])
	end

	it "should return multiple locations if there is more than one square with exactly 3 neighbours" do
		c12 = new_universe.new_cell(1,2)
		c22 = new_universe.new_cell(2,2)
		c23 = new_universe.new_cell(2,3)
		new_universe.set_bounds
		new_universe.where_to_reanimate.should include([1,3])
		new_universe.where_to_reanimate.should include([2,1])		
	end
end


describe Universe, "#what_to_kill" do

	new_universe = Universe.new
	c10 = new_universe.new_cell(1,0)
	c11 = new_universe.new_cell(1,1)
	c12 = new_universe.new_cell(1,2)
	c20 =new_universe.new_cell(2,0)
	c22 = new_universe.new_cell(2,2)
	new_universe.set_bounds

 	it "should kill c11 only" do
		new_universe.world -= new_universe.what_to_kill
		new_universe.world.should_not include(c11)
		new_universe.world.should include(c10)
		new_universe.world.should include(c20)
		new_universe.world.should include(c12)
		new_universe.world.should include(c22)
	end

end

describe Universe, "#reanimate!" do

	it "should reanimate c(0,1) leaving all other cells the same" do
		new_universe = Universe.new
		c10 = new_universe.new_cell(1,0)
		c11 = new_universe.new_cell(1,1)
		c12 = new_universe.new_cell(1,2)
		c20 =new_universe.new_cell(2,0)
		c22 = new_universe.new_cell(2,2)
		new_universe.set_bounds
		new_universe.reanimate!

	 	
		new_universe.world.should include(c10)
		new_universe.world.should include(c11)
		new_universe.world.should include(c12)
		new_universe.world.should include(c20)
		new_universe.world.should include(c22)
		#it should also have an additional Cell object  at x,y = (0,1) at the end
		new_universe.world[-1].x.should eq(0)
		new_universe.world[-1].y.should eq(1)
	end

	it "should reanimate cells at (0,1) (0,2) (0,3) (2,1) (2,2) and (2,3)" do
		new_universe = Universe.new
		c10 = new_universe.new_cell(1,0)
		c11 = new_universe.new_cell(1,1)
		c12 = new_universe.new_cell(1,2)
		c13 =new_universe.new_cell(1,3)
		c14 = new_universe.new_cell(1,4)
		new_universe.set_bounds
		new_universe.reanimate!

		new_cells = []
		new_cells = new_universe.world[-6,6]

		new_universe.world[-6].x.should eq(0)
		new_universe.world[-6].y.should eq(1)
		new_universe.world[-5].x.should eq(0)
		new_universe.world[-5].y.should eq(2)
		new_universe.world[-4].x.should eq(0)
		new_universe.world[-4].y.should eq(3)
		new_universe.world[-3].x.should eq(2)
		new_universe.world[-3].y.should eq(1)
		new_universe.world[-2].x.should eq(2)
		new_universe.world[-2].y.should eq(2)
		new_universe.world[-1].x.should eq(2)
		new_universe.world[-1].y.should eq(3)
	end

end

describe Universe, "#tick!" do

	new_universe = Universe.new
	c10 = new_universe.new_cell(1,0)
	c11 = new_universe.new_cell(1,1)
	c12 = new_universe.new_cell(1,2)
	
	new_universe.set_bounds

 	it "should accurately kill c10 and c12, leave c11 alive, and reanimate (0,1) and (2,1)" do
		new_universe.tick!
		new_universe.world.should_not include(c10)
		new_universe.world.should_not include(c12)
		new_universe.world.should include(c11)
		new_universe.world[-2].x.should eq(0)
		new_universe.world[-2].y.should eq(1)
		new_universe.world[-1].x.should eq(2)
		new_universe.world[-1].y.should eq(1)
	end

end