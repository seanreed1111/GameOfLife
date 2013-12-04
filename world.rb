require './cell'
#  Rule1   Any live cell with fewer than two live neighbors dies
#  Rule2   Any live cell with two or three live neighbors lives on to the next generation.
#  Rule3   Any live cell with more than three live neighbors dies
#  Rule4   Any dead cell with exactly three live neighbors becomes a live cell

class World
	attr_accessor :world, :bounds

	def initialize
		@world = []
		@bounds = []
	end

	def new_cell(x,y)
		cell = Cell.new(x,y)
		self.world << cell
		cell
	end

	def num_of_neighbors(x,y)
		#loop runs 8 times, since each point can have a max of 8 neighbors
		#scan each point on square -1,0, or 1 away from (x,y), on both the x and y axes.
		neighbors =[]
		for i in (-1..1)
			for j in (-1..1)
				next if (i==0 && j==0) #since we are looking for neighbors AROUND (x,y), not AT (x,y)
				neighbors << [x+i, y+j] if self.alive?((x+i), (y+j)) 
				#neighbors doesn't give the actual cells, only the locations of the cells
			end
			
		end
		neighbors.length
	end

	def alive?(x_coor,y_coor)
		alive = false
		self.world.each do |cell|
			alive = true if (cell.x == x_coor && cell.y == y_coor)
		end
		alive
	end



	#world can now loop through all the cells in the world and tell them 
	#if they are alive or dead after the tick!
	# loop over all cells in the world, and if the cells are dead in the next round 
	#then remove from the world 
	
	


	def set_bounds #returns range of x and range of y to check for possible reincarnation of dead cells
		self.bounds = []
		x=[]
		y=[]
		self.world.each do |cell|
			x<< cell.x
			y<< cell.y
		end

		self.bounds << x.min-1<< x.max+1 << y.min-1 << y.max+1
	end

	def kill_live_cells_if_needed!
		#  Rule1   Any live cell with fewer than two live neighbors dies
		#  Rule2   Any live cell with two or three live neighbors lives
		#  Rule3   Any live cell with more than three live neighbors dies
		puts "the world is currently #{self.world.inspect}"

		self.world.each do |cell|
			neighbors = self.num_of_neighbors(cell.x, cell.y) #computes number of neighbors using TEMP! 
			puts "# of neighbors for cell #{cell.inspect} is #{neighbors}"
			if (neighbors < 2 || neighbors > 3)
				puts "deleting cell #{cell.inspect}"

				self.world.delete(cell)
				puts "the world is now #{self.world.inspect}"
			end
		end
	end

	def reincarnation_locations
		#  Rule4   Any dead cell with exactly three live neighbors becomes a live cell
		#reincarnation_locations returns an array of the [x,y] locations of 
		#cells that should be brought back to life
		#!!!!BUT SHOULD NOT BE AT LOCATION OF CELL ALIVE AT t=T!!!!!

		self.set_bounds
		locations = []
		for x in ((self.bounds[0])..(self.bounds[1]))
			for y in ((self.bounds[2])..(self.bounds[3]))
				if num_of_neighbors(x,y) == 3 && !alive?(x,y)#three neighbors && cell currently dead
					locations << [x,y] 
				end
			end
		end
		locations
	end

	def reincarnate!(new_cell_locations)
		if new_cell_locations.length != 0
			new_cell_locations.each do |x,y|
				self.new_cell(x,y) if !alive?(x,y)
			end
		end	
	end

	def tick!
		new_cell_locations = []
		new_cell_locations = self.reincarnation_locations
		self.kill_live_cells_if_needed!
		self.reincarnate!(new_cell_locations)
	end


end