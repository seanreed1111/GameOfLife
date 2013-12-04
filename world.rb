require './cell'
#  Rule1   Any live cell with fewer than two live neighbours dies
#  Rule2   Any live cell with two or three live neighbours lives on to the next generation.
#  Rule3   Any live cell with more than three live neighbours dies
#  Rule4   Any dead cell with exactly three live neighbours becomes a live cell

class World
	attr_reader :world

	def initialize
		@world = []
	end

	def new_cell(x,y)
		cell = Cell.new(x,y)
		@world << cell
		cell
	end

	def num_of_neighbors(x,y)
		neighbors =[]
		for i in (-1..1)
			for j in (-1..1)
				next if (i==0 && j==0)
				neighbors << [x+i, y+j] if alive?((x+i), (y+j)) 
				#neighbors doesn't give the actual cells, only the locations of the cells
				#but I think that is ok, because I can just look at the length of neighbors to tell if
				#the cell should be alive or dead for the next round
			end
			
		end
		neighbors.length
	end

	def alive?(x_coor,y_coor)
		alive = false
		self.world each do cell
			alive = true if (cell.x == x_coor and cell.y == y_coor)
		end
		alive
	end



	#world can now loop through all the cells in the world and tell them if they is alive or dead after the tick!
	# loop over all cells in the world, and if the cells are dead in the next round then remove from the world 
	
	#tick! does the following
	# copies the @world array (t=T) into a TEMP variable
	# checks to see which alive cells stay alive at T+1
	# 	kill all alive cells that died in T+1 by removing them from TEMP 
	#checks which dead cells get brought to life at T+1
			# for finding dead cells that might become alive, can find the min and max x and y values, and bound
			# your search over the array there.
	# 	add a new cell to temp array for each cell brought back to life
	# Finally, set @world = TEMP to update the new state of the world


	def find_search_boundaries #version 1
		x=[]
		y=[]
		self.world.each do |cell|
			x<< cell.x
			y<< cell.y
		end

		x.min, x.max, y.min, y.max
	end

	def bring_dead_cells_to_life!
		#finds search boundaries, 
		#returns locations of new cells that are now alive.
		#makes sure these spaces don't already have a live cell in them
		#then put a live cell in all the places that don't have one

		#returns an array of cells
		self.find_search_boundaries
	end

	def tick!

		temp_world = World.new
		temp_world = self
		temp_world.each do |cell|
			neighbors = temp_world.num_of_neighbors(cell.x, cell.y)
			# loop through to find out which cells stay alive this round
			#  Rule1   Any live cell with fewer than two live neighbours dies
			#  Rule2   Any live cell with two or three live neighbours lives
			#  Rule3   Any live cell with more than three live neighbours dies
			if (neighbors < 2 || neighbors > 3)
				temp_world.world -= cell
			end
		end
		#now, loop through all the dead cells to see which comes to life
		#Need to loop through the entire world
		#How do you know the boundaries of the world as it exists in self?
		#need to loop out one more row and column away from the max and min x and y values
		#insert code here
		# Rule4   Any dead cell with exactly three live neighbours becomes a live cell

		self.bring_dead_cells_to_life! #call it on self because you haven't killed any cells yet.
		#also can just kill the cells first!


		#finally, copy temp_world into self.world and end the function
		self.world = temp_world.world
	end


end