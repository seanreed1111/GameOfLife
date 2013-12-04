require './cell'
#  Rule1   Any live cell with fewer than two live neighbours dies
#  Rule2   Any live cell with two or three live neighbours lives on to the next generation.
#  Rule3   Any live cell with more than three live neighbours dies
#  Rule4   Any dead cell with exactly three live neighbours becomes a live cell

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
		self.world.each do |cell|
			alive = true if (cell.x == x_coor && cell.y == y_coor)
		end
		alive
	end



	#world can now loop through all the cells in the world and tell them if they is alive or dead after the tick!
	# loop over all cells in the world, and if the cells are dead in the next round then remove from the world 
	
	


	def set_bounds #version 1
		self.bounds = []
		x=[]
		y=[]
		self.world.each do |cell|
			x<< cell.x
			y<< cell.y
		end

		self.bounds << x.min-1<< x.max+1 << y.min-1 << y.max+1
	end

	def reincarnation_locations
		#reincarnate returns array of the x,y locations of 
		#cells that should be brought back to life

		#Note: set_bounds should be called before this method is run
		# puts "self.bounds[0] = #{self.bounds[0]}"
		# puts "self.bounds[1] = #{self.bounds[1]}"
		# puts "self.bounds[2] = #{self.bounds[2]}"
		# puts "self.bounds[3] = #{self.bounds[3]}"
		locations = []
		for x in ((self.bounds[0])..(self.bounds[1]))
			for y in ((self.bounds[2])..(self.bounds[3]))
				if num_of_neighbors(x,y) == 3
					locations << [x,y] 
				end
			end
		end
		locations
	end

#tick! does the following
	# copies the @world array (t=T) into a TEMP variable
	# checks to see which alive cells stay alive at T+1
	# 	kill all alive cells that died in T+1 by removing them from TEMP 
	#checks which dead cells get brought to life at T+1
			# for finding dead cells that might become alive, can find the min and max x and y values, and bound
			# your search over the array there.
	# 	add a new cell to temp array for each cell brought back to life
	# Finally, set @world = TEMP to update the new state of the world

	def tick!
		#can further break tick down into kill_live_cells! and reincarnate!
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
		# Rule4   Any dead cell with exactly three live neighbours lives again
		self.set_bounds
		new_cell_locations = self.reincarnation_locations #returns array of x,y locations of cells to be reincarnated
		
		#now, add these new cell locations to temp_world 
		#iff they don't already exist in temp_world

		if new_cell_locations.length != 0
			new_cell_locations.each do |x,y|
				temp_world.new_cell(x,y) if !alive?(x,y)
			end
		end	


		#finally, since temp_world now has all the cells that should exist
		# for t=T+1, copy temp_world into self.world
		self.world = temp_world.world
	end


end