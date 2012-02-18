=begin
	Assignment: Program 9 - Knight's Tour
	Author: Clayton Thomas
	Date: 4/2/11
	Class: CS 2430-004
	Description: Calculates a single knight's tour path using the Warnsdorff algorithm, which places a knight
	on a space chosen at random. The next move is chosen by evaluating each available space, and the number 
	of available subsequent moves from that space. The space with the least available moves is chosen, and 
	this process is repeated until every square on the $moves has been visited.
=end

##############
# GLOBAL VARS
##############

# define $moves (global var) which will be a board that holds each move # on its corresponding square
$moves = Array.new(8)

# list version of coordinates visited, in order
$move_list = Array.new

# move counter (global var), so we know what next move # will be
$move_ct = 1


###############
# CORE METHODS
###############

# makes next move, based on Warnsdorff calculations. takes coordinate point
def mkmove(x, y)
	# get list of available spaces, starting from a given space
	avail_sp = avail(x, y)
	#print avail_sp.length
	
	# find number of open spaces available from each possible space (i.e., go another level deep)
	cnt_list = num_choices(avail_sp)
	#puts cnt_list
	
	# calculate smallest num avail moves - var "smallest" holds this value, "smallest_in" is index of this value
	smallest = cnt_list[0]
	smallest_i = 0
	cnt_list.each_index do |x|
		if(cnt_list[x] < smallest)
			smallest = cnt_list[x]
			smallest_i = x
		end
	end
	
	#print "smallest is ", smallest_i
	
	# mark space that has fewest possible places to go as next move
	$moves[avail_sp[smallest_i][0]][avail_sp[smallest_i][1]] = $move_ct
	$move_list << "[" + avail_sp[smallest_i][0].to_s + "][" + avail_sp[smallest_i][1].to_s + "]"
	$move_ct += 1
	
	#if move count is less than 65 (i.e. board is not complete), calculate next move based on space that has fewest possible places to go (Warnsdorff algorithm)
	if($move_ct < 65)
		mkmove(avail_sp[smallest_i][0], avail_sp[smallest_i][1])
	end
end

# calculate available squares to move to for any given space, represented as a coordinate pair. Squares already visited have values > 0, unvisited squares = 0
# 0,0 is top left corner; 7,7 is bottom right
def avail(x, y)
	# holds list of available coordinate pairs
	list_xy = Array.new
	
	# up to 8 avail moves, so check all directions. for each pt, check if coordinate is within board range, and that that point has not been visited
	
	# left 1, up 2
	if(x-1 >= 0 and x-1 <= 7 and y-2 >= 0 and y-2 <= 7 and $moves[x-1][y-2] == 0)
		list_xy << [x-1, y-2]
	end
	
	# left 2, up 1
	if(x-2 >= 0 and x-2 <= 7 and y-1 >= 0 and y-1 <= 7 and $moves[x-2][y-1] == 0)
		list_xy << [x-2, y-1]
	end
	
	# left 2, down 1
	if(x-2 >= 0 and x-2 <= 7 and y+1 >= 0 and y+1 <= 7 and $moves[x-2][y+1] == 0)
		list_xy << [x-2, y+1]
	end
	
	# left 1, down 2
	if(x-1 >= 0 and x-1 <= 7 and y+2 >= 0 and y+2 <= 7 and $moves[x-1][y+2] == 0)
		list_xy << [x-1, y+2]
	end
	
	# right 1, down 2
	if(x+1 >= 0 and x+1 <= 7 and y+2 >= 0 and y+2 <= 7 and $moves[x+1][y+2] == 0)
		list_xy << [x+1, y+2]
	end
	
	# right 2, down 1
	if(x+2 >= 0 and x+2 <= 7 and y+1 >= 0 and y+1 <= 7 and $moves[x+2][y+1] == 0)
		list_xy << [x+2, y+1]
	end
	
	# right 2, up 1
	if(x+2 >= 0 and x+2 <= 7 and y-1 >= 0 and y-1 <= 7 and $moves[x+2][y-1] == 0)
		list_xy << [x+2, y-1]
	end
	
	# right 1, up 2
	if(x+1 >= 0 and x+1 <= 7 and y-2 >= 0 and y-2 <= 7 and $moves[x+1][y-2] == 0)
		list_xy << [x+1, y-2]
	end
	
	return list_xy
end

# count number of available spaces from any given square - used for Warnsdorff algorithm.
# expects an array of coordinate pairs (also arrays)
def num_choices(list_xy)
	# hold number of moves for all available moves
	count = Array.new

	# for each coordinate pair, calculate available squares, then count total
	list_xy.each_index do |z|
		count << avail(list_xy[z][0], list_xy[z][1]).length
	end
	
	return count
end

# print board with move number in each space, then prints list of moves
def print_bd
	puts "Board with counts:"
	$moves.each_index do |x|
		$moves[x].each_index do |y|
			print $moves[x][y], "\t"
		end
		print "\n"
	end
	
	print "\n"
	puts "List of coordinates visited, in order:"
	$move_list.each_index do |y|
		print $move_list[y], "\t"
	end
	print "\n"
end


################
# INITIAL SETUP
################

# flesh out $moves as 8x8 2-dim array; fill $moves with 0's, to indicate that no squares have been visited
$moves.each_index do |x|
	$moves[x] = Array.new(8)
	
	$moves[x].each_index do |y|
		$moves[x][y] = 0
	end
end

# place first knight at random position, increment move counter
i1 = rand(8)
i2 = rand(8)
$moves[i1][i2] = 1
$move_ct += 1
$move_list << "[" + i1.to_s + "][" + i2.to_s + "]"

#####################
# FIND THE SEQUENCE!
#####################

mkmove(i1, i2)

# tour is complete - print the board and list of moves!
print_bd

# pause before closing
gets
