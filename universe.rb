require './cell'
#  Rule1   Any live cell with fewer than two live neighbors dies
#  Rule2   Any live cell with two or three live neighbors lives on to the next generation.
#  Rule3   Any live cell with more than three live neighbors dies
#  Rule4   Any dead cell with exactly three live neighbors becomes a live cell

class Universe
	attr_accessor :world, :bounds

	def initialize
		@world = []
		@bounds = []
	end

	def new_cell(x,y)
		cell = Cell.new(x,y)
		world << cell
		cell
	end

	def num_of_neighbors(x,y)
		#loop runs 8 times, since each point can have a max of 8 neighbors
		#scan each point on square -1,0, or 1 away from (x,y), on both the x and y axes.
		neighbors =[]
		for i in (-1..1)
			for j in (-1..1)
				next if (i==0 && j==0) #since we are looking for neighbors AROUND (x,y), not AT (x,y)
				if alive?((x+i), (y+j))
					neighbors << [x+i, y+j]
				end
			end
			
		end
		neighbors.length
	end


	def neighbors(x,y)
		#loop runs 8 times, since each point can have a max of 8 neighbors
		#scan each point on square -1,0, or 1 away from (x,y), on both the x and y axes.
		neighbors =[]
		for i in (-1..1)
			for j in (-1..1)
				next if (i==0) && (j==0) #since we are looking for neighbors AROUND (x,y), not AT (x,y)
				if alive?((x+i), (y+j))
					neighbors << [x+i, y+j]
				end
			end
			
		end
		neighbors
	end

	def alive?(x_coor,y_coor)
		alive = false
		@world.each do |cell|
			alive = true if (cell.x == x_coor && cell.y == y_coor)
		end
		alive
	end

	def set_bounds #returns range of x and range of y to check for possible reincarnation of dead cells
		@bounds = []
		x=[]
		y=[]
		@world.each do |cell|
			x<< cell.x
			y<< cell.y
		end

		@bounds << x.min-1<< x.max+1 << y.min-1 << y.max+1
	end

	def kill_live_cells_if_needed!
		#  Rule1   Any live cell with fewer than two live neighbors dies
		#  Rule2   Any live cell with two or three live neighbors lives
		#  Rule3   Any live cell with more than three live neighbors dies
		puts "the world is currently #{world.inspect}"

		temp_array = [] #captures the array of cells that needs to be deleted

		@world.each do |cell|
			
			neighbors_array = neighbors(cell.x, cell.y)
			puts "neighbors for cell #{cell.inspect} is #{neighbors_array.inspect}"
			if (neighbors_array.length < 2 || neighbors_array.length > 3)
				puts "deleting cell #{cell.inspect}"
				temp_array << cell
				puts "the world is now #{world.inspect}"
			end
		end
		@world -= temp_array #removes the live cells in temp_array marked for death from the world
	end

	def reincarnation_locations
		#  Rule4   Any dead cell with exactly three live neighbors becomes a live cell
		#reincarnation_locations returns an array of the [x,y] locations of 
		#cells that should be brought back to life
		#!!!!BUT SHOULD NOT BE AT LOCATION OF CELL ALIVE AT t=T!!!!!

		set_bounds
		locations = []
		for x in ((@bounds[0])..(@bounds[1]))
			for y in ((@bounds[2])..(@bounds[3]))
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
				new_cell(x,y) if !alive?(x,y)
			end
		end	
	end

	def tick!
		new_cell_locations = []
		new_cell_locations = reincarnation_locations
		kill_live_cells_if_needed!
		reincarnate!(new_cell_locations)
	end


end