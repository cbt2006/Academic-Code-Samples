=begin
	Assignment: Program 10 - Huffman compression
	Author: Clayton Thomas
	Date: 4/9/11
	Class: CS 2430-004
	Description: Compresses a text file based upon the Huffman compression algorithm, which involves reading a file,
	counting the number of each characters, and then assigning each of those characters a string of bits, such that
	the most frequent characters have the shortest bit strings, and the rarest characters have the longest bit representation.
	The result is typically a significant degree of file compression.

	This code provides the ability to both compress text files, and decompress an already compressed file.

=end

####################

# node of a binary Huffman tree
class Node
	def initialize(count=nil, char=nil, left=nil, right=nil)
		@left = left
		@right = right
		@char = char
		@count = count
	end
	def set_left(node)
		@left = node
	end
	def set_right(node)
		@right = node
	end
	def set_char(val)
		@char = val
	end
	def set_count(val)
		@count = val
	end
	def get_left
		return @left
	end
	def get_right
		return @right
	end
	def get_char
		return @char
	end
	def get_count
		return @count
	end
end

# takes 2 args, file handle and array to hold character counts. reads file char by char, and either 
# creates entry in array for a char and sets count to 1 (if it doesn't already exist), or else increments char count.
def count_chars(file)
	ch_arr = Hash.new
	file.each_line { |line|
		line.each_char { |c|
			if(ch_arr[c] == nil)
				ch_arr[c] = 1
			else
				ch_arr[c] += 1
			end
		}
	}
	return ch_arr
end

# builds binary tree out of array of character counts in a file. smaller counts go to left, larger counts go to right.
def mk_tree(ch_arr)
	# set up top node based on smallest 2 values
	top = Node.new # initial top node; no values yet
	mins = min_vals(ch_arr, 2)
	puts mins[0], mins[1]
	puts ch_arr[mins[0]]
	puts ch_arr[mins[1]]
	top.set_left(Node.new(ch_arr[mins[0]], mins[0]))
	top.set_right(Node.new(ch_arr[mins[1]], mins[1]))
	top.set_count(ch_arr[mins[0]] + ch_arr[mins[1]])
	ch_arr.delete(mins[0])
	ch_arr.delete(mins[1])
	# build tree based upon current top node and next smallest value; repeat until no values left in hash
	while(ch_arr.length >= 1)
		temp = Node.new # temporary new node; this will become the top node
		min = min_vals(ch_arr, 1)
		puts min
		puts ch_arr[min]
		# if top node's value is less than lowest number, put it on left; otherwise, put it on right
		#puts top.get_count, ch_arr[min]
		if(top.get_count <= ch_arr[min])
			temp.set_left(top)
			temp.set_right(Node.new(ch_arr[min], min))
		else
			temp.set_left(Node.new(ch_arr[min], min))
			temp.set_right(top)
		end
		temp.set_count(ch_arr[min] + top.get_count)
		top = temp
		ch_arr.delete(min)
	end
	# return reference to top node
	return top
end

# finds the smallest values in a set, then returns the indexes of those values (i.e. the characters, not their counts).
# used for building Huffman tree.
# if num_vals is 2, then returns smallest two val indexes (used for building top node of tree)
# if num_vals is 1, then returns only the least common value
def min_vals(ch_arr, num_vals)
	total = 0 # holds total number of chars in file
	ch_arr.each do |key, value|
		total += value
	end
	if(num_vals == 2)
		min_v = total # set minimum to length of file, which will always be at least as large as char with highest count
		scd_min_v = 0 # 2nd min count; dummy val of zero, since this will be changed when min value is changed
		min_i = "" # index of smallest count; dummy value
		scd_min_i = "" # index of 2nd smallest count; dummy value
		ch_arr.each { |i, v|
			if(ch_arr[i] <= min_v)
				scd_min_v = min_v
				min_v = v
				scd_min_i = min_i
				min_i = i
			end
		}
		return min_i, scd_min_i
	elsif(num_vals == 1)
		min_v = total # set minimum to length of file, which will always be at least as large as char with highest count
		min_i = "" # index of smallest count; dummy value
		ch_arr.each { |i, v|
			if(ch_arr[i] <= min_v)
				min_v = v
				min_i = i
			end
		}
		return min_i
	end
end


# search tree for char value, return sequence of 1's and 0's
# bit_seq is empty string to start, but will become sequence of 1's and 0's that corresponds to character
def encode(tree, c, bit_seq="")
	sub_tree = nil # reference to sub-searches
	if(tree.get_char == c)
		return bit_seq
	end
	if(tree.get_left != nil) # go left if possible
		bit_seq << "0"
		sub_tree = encode(tree.get_left, c)
		if(sub_tree != false)
			bit_seq << sub_tree
			return bit_seq
		elsif(tree.get_right != nil) # we've checked left branch and didn't find it so backed up, so now go right if possible
			bit_seq << "1"
			sub_tree = encode(tree.get_right, c)
			if(sub_tree != false)
				bit_seq << sub_tree
				return bit_seq
			else
				bit_seq.slice!(bit_seq.length-1) # remove last char from list, since we have to go back up the tree
				return false
			end
		end
	elsif(tree.get_right != nil) # we've checked left branch and didn't find it so backed up, so now go right if possible
		bit_seq << "1"
		sub_tree = encode(tree.get_right, c)
		if(sub_tree != false)
			bit_seq << sub_tree
			return bit_seq
		else
			bit_seq.slice!(bit_seq.length-1) # remove last char from list, since we have to go back up the tree
			return false
		end
	else # by this point we know there are no more left or right branches and we've dead-ended, so back up
		bit_seq.slice!(bit_seq.length-1) # remove last char from list, since we have to go back up the tree
		return false
	end
end

# search tree based on binary input. if 0, go left, or if 1, go right branch. then read next bit.
# if next bit matches an available branch, follow it; else, we have the char, so read it and output.
# takes a file handle (the encoded file), code table, output file as args.
def decode(input=nil, codes=nil, output=nil)
	codes.default = false # set value that is returned if value is not found in hash
	text = input.read # converts file to String - won't work otherwise for me
	c = text[0]
	i = 1 # counter for string
	while(i < text.length)
		until(codes[c] != false or i > 100)
			c += text[i]
			i += 1
		end
		if(codes[c] != false)
			output.write(codes[c])
			c = ""
		end
		# at this point, a match has been found
		#puts codes[c] == false
	end
end

# builds a hash that holds char-to-bit translation, based on constructed tree.
# takes tree and hash of chars/counts from file as args.
# goes through list of chars, finds bit series version of each, and puts them into a hash file for easy
# compression/decompression reference.
# invert arg decides arrangement of chars vs. bits - if 0, char is key; if 1, bits encoding is key
def build_code(tree, ch_arr, invert)
	code_table = Hash.new
	if(invert == 0)
		ch_arr.each { |key, value|
			code = encode(tree, key)
			code_table[key] = code
		}
	elsif(invert==1)
		ch_arr.each { |key, value|
			code = encode(tree, key)
			code_table[code] = key
		}
	end
	return code_table
end

####################################
# Run program
# Prompt for user input
####################################

encdec = 1
print "Your present working directory is ", Dir.pwd, ". Please put text files in that directory before continuing.\n"
print "Type file name: "
file = gets
text = File.open(Dir.pwd + "/" + file.strip, "r")

char_ct = count_chars(text) # char_ct is type Hash
text.rewind # move pointer back to start of file so we can read it again
tree = mk_tree(char_ct)
char_ct = count_chars(text) # create another hash of the same, since build_code() mangles the original char_ct
code_table = build_code(tree, char_ct, 0)
char_ct = count_chars(text) # create another hash of the same, since build_code() mangles the original char_ct
output = File.new(Dir.pwd + "/" + file.strip + "-code.txt", "wb") # new file containing bit series
text.rewind # move pointer back to start of file again so we can read it yet again
text.each_line {|line|
	line.each_char { |c|
		output.print(code_table[c])
	}
}
text.rewind
output.close

enc_txt = File.open(Dir.pwd + "/" + file.strip + "-code.txt", "r")
output = File.new(Dir.pwd + "/upton.txt", "w")

char_ct = count_chars(text) # re-create this hash again
code_table = build_code(tree, char_ct, 1)
code_table.default = false

decode(enc_txt, code_table, output)
output.close

# pause before close
gets