require './cell'
#  Rule1   Any live cell with fewer than two live neighbors dies
#  Rule2   Any live cell with two or three live neighbors lives on to the next generation.
#  Rule3   Any live cell with more than three live neighbors dies
#  Rule4   Any dead cell with exactly three live neighbors becomes a live cell

class Universe
	attr_accessor :world, :bounds
	attr_reader :cell_coordinates

	def initialize
		@world = []
		@bounds = []
		@cell_coordinates = []
	end

	def new_cell(x,y)
		cell = Cell.new(x,y)
		world << cell
		cell
	end

	def populate!(number_of_cells=10, size_of_grid=10)
		1.upto(number_of_cells) {new_cell(1+rand(size_of_grid/2.0), 1+rand(size_of_grid/2.0))}
	end

	def blinker!
		1.upto(3) {|i| new_cell(5,i+5)}
	end

	def go!
		1.upto(10) {|i| new_cell(10,i+5)}
	end


	def set_cell_coordinates! #needed for printing
		@cell_coordinates = []
		@world.each {|cell| @cell_coordinates << [cell.x,cell.y]}
	end


	def print_universe
		puts "\e[H"
		set_cell_coordinates!
		for y in (1..25)        #default screen size is 5
			print "\n"
			for x in (1..25)
				if @cell_coordinates.include?([x,y])
					print "*"
				else
					print "."
				end
			end
		end
	end

	def dead?(x_coor,y_coor)
		!alive?(x_coor,y_coor)
	end

	def alive?(x_coor,y_coor)
		alive = false
		@world.each do |cell|
			alive = true if (cell.x == x_coor && cell.y == y_coor)
		end
		alive
	end



	def set_bounds #creates an grid of min and max range of x and y to check for possible reincarnation of dead cells
		@bounds = []
		x=[]
		y=[]
		@world.each do |cell|
			x<< cell.x
			y<< cell.y
		end

		@bounds << x.min-1<< x.max+1 << y.min-1 << y.max+1
	end

	def neighbors(x,y)
		#loop runs total of 8 times, since each point (x,y) on grid can have a max of 8 neighbors
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


	def what_to_kill
		#  Rule1   Any live cell with fewer than two live neighbors dies
		#  Rule2   Any live cell with two or three live neighbours lives on to the next generation.
		#  Rule3   Any live cell with more than three live neighbors dies

		dead_cells = [] 

		@world.each do |cell|
			neighbors_array = neighbors(cell.x, cell.y)
			if (neighbors_array.length < 2 || neighbors_array.length > 3) #uses rules 1-3
				dead_cells << cell
			end
		end
		dead_cells
	end


	def where_to_reanimate
		#  Rule4   Any dead cell with exactly three live neighbors becomes a live cell
		#reincarnation_locations returns an array of the [x,y] locations of 
		#cells that should be brought back to life
		#!!!!BUT SHOULD NOT BE AT LOCATION OF CELL ALIVE AT t=T!!!!!

		set_bounds
		locations = []
		for x in ((@bounds[0])..(@bounds[1]))
			for y in ((@bounds[2])..(@bounds[3]))
				if neighbors(x,y).length == 3 && dead?(x,y)  #three neighbors && cell is dead
					locations << [x,y] 
				end
			end
		end
		locations
	end

	def reanimate! ##brings new cells to life in the universe if there is at least one new cell to create
		where_to_reanimate.each {|x,y| new_cell(x,y)}	
	end


	def tick!
		dead_cells = []
		dead_cells = what_to_kill
		reanimate!  
		@world -= dead_cells #gets rid of the dead cells in the universe
	end

################################################################
	#using these methods for debugging purposes only
################################################################
# 	def kill_live_cells_if_needed!
# 		#  Rule1   Any live cell with fewer than two live neighbors dies
# 		#  Rule2   Any live cell with two or three live neighbors lives
# 		#  Rule3   Any live cell with more than three live neighbors dies
# #		puts "the world is currently #{world.inspect}"

# 		temp_array = [] #captures the cells that needs to be deleted

# 		@world.each do |cell|
			
# 			neighbors_array = neighbors(cell.x, cell.y)
# #			puts "neighbors for cell #{cell.inspect} is #{neighbors_array.inspect}"
# 			if (neighbors_array.length < 2 || neighbors_array.length > 3)
# #				puts "deleting cell #{cell.inspect}"
# 				temp_array << cell
# #				puts "the world is now #{world.inspect}"
# 			end
# 		end
# 		@world -= temp_array #removes the live cells in temp_array marked for death from the world
# 	end



	# def num_of_neighbors(x,y)
	# 	#loop runs 8 times, since each point can have a max of 8 neighbors
	# 	#scan each point on square -1,0, or 1 away from (x,y), on both the x and y axes.
	# 	neighbors =[]
	# 	for i in (-1..1)
	# 		for j in (-1..1)
	# 			next if (i==0 && j==0) #since we are looking for neighbors AROUND (x,y), not AT (x,y)
	# 			if alive?((x+i), (y+j))
	# 				neighbors << [x+i, y+j]
	# 			end
	# 		end
			
	# 	end
	# 	neighbors.length
	# end
end