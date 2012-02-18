=begin
	Assignment: Program 4 - Cipher Program
	Author: Clayton Thomas
	Date: 1/30/11
	Class: CS 2430-004
	Description: Encodes or Decodes a message based on custom cipher algorithm.  Also implements RSA encryption.
=end

########################
# Function Definitions
########################

# converts A-Z to numbers 0-25, in a case-insensitive way
# rsa is a boolean, if true zeros are pre-pended to single digit numbers
def make_num(msg, rsa)
	msg.upcase! #convert to uppercase
	msg = msg.strip #strip out carriage return and new line chars, which are included in the input
	new_msg = Array.new # to hold converted values
	msg.each_byte do |i|
		if i == 32
			new_msg << 32 # if it's a space, leave it alone
		elsif i == 0 && rsa == false # check for null chars - ignore them if found, which they will be at the end of Ruby Strings
			next # skip to next character
		else # regular letter found
			# subtract ASCII value for uppercase to get Caesar value - e.g., A = ASCII 65, so we make it 0.
			# then append to the new_msg var and return it
			tmp = i - 65
			# append numeric values to new_msg array - if RSA mode enabled, convert to strings, so that leading zeroes are not stripped out
			# if not RSA mode, just append straight integers.
			# if RSA mode is enabled, then prepend a zero to any single-digit number (this is a formatting requirement for number input)
			if(rsa) && tmp < 10 
				tmp = ("0" + tmp.to_s)
				new_msg << tmp
			elsif(rsa)
				new_msg << tmp.to_s
			else
				new_msg << tmp.to_i
			end
		end
	end
	
	# if RSA mode, combine pairs of 2-digit numbers into a single value
	if(rsa)
		concat_msg = Array.new
		0.step(new_msg.length-1, 2) do |i|
			tmp_arr = new_msg[i].to_s + new_msg[i+1].to_s
			concat_msg << tmp_arr
		end
		return concat_msg
	end
	
	return new_msg
end


# converts an encoded msg - an array - coded as numbers 0-25, from A-Z respectively, to their proper ASCII char values
def make_msg(arr)
	new_msg = ""
	arr.each do |i| # remember, i is the VALUE, not the index! use each_index if you want i to equal the index on each iteration
		if i == 32
			new_msg << " " # if it's a space, leave it alone
		else
			new_msg << (i + 65).chr # convert ints to chars and append
		end
	end
	
	return new_msg
end

# encodes/decodes a numeric message using Caesar cipher
def caesar_ciph(encode, shift, msg)
	ciph_val = Array.new # to hold encoded/decoded numeric message
	if encode == 1 #encoding
		msg.each do |i|
			# if space, ignore and skip to next char
			if i.to_i == 32
				ciph_val << i.to_i
				next
			end
			shift_tmp = shift.sub(/[a-zA-Z]/, i.to_s) # searches shift peram for a variable letter, substitutes current value of i for it
			shift_tmp = eval(shift_tmp).to_i # evaluate cipher code with current value
			shift_tmp = shift_tmp % 26 # perform mod of shifted value
			ciph_val << shift_tmp
		end
	elsif encode == 2 #decoding
		# if shift includes addition or subtraction, invert it
		if shift =~ /\+/
			shift = shift.sub(/\+/, "-")
		elsif shift =~ /\-/
			shift = shift.sub(/\-/, "+")
		end
		# perform inverted mod for each number
		msg.each do |j|
			# if space, ignore and skip to next char
			if j.to_i == 32
				ciph_val << j.to_i
				next
			end
			shift_tmp = shift.sub(/[a-zA-Z]/, j.to_s)
			shift_tmp = eval(shift_tmp).to_i
			shift_tmp = shift_tmp % 26
			ciph_val << shift_tmp
		end
	else
		puts "Invalid cipher code, please restart and try again."
	end
	
	return ciph_val
end

# RSA encryption/decryption algorithm - msg is passed in as an array of 4-char strings
def rsa(msg, encode)
	# assuming e=13, p=43, q=59 - so n = 2537
	if encode==1
		c = nil
		new_msg = Array.new
		msg.each_index do |i|
			c = ((msg[i].to_i)**13) % 2478
			if c < 10
				c = "000" + c.to_s
			elsif c < 100
				c = "00" + c.to_s
			elsif c < 1000
				c = "0" + c.to_s
			else
				c = c.to_s
			end
			new_msg << c
		end
	elsif encode == 2
		# d = 937
		p = nil
		new_msg = Array.new
		msg.each_index do |i|
			p = ((msg[i].to_i)**937) % 2537
			if p < 10
				p = "000" + p.to_s
			elsif p < 100
				p = "00" + p.to_s
			elsif p < 1000
				p = "0" + p.to_s
			else
				p = p.to_s
			end
			new_msg << p
		end
	end
	return new_msg
end

# converts RSA group array into text msg
def rsa_msg(arr)
	arr = arr.join
	msg = Array.new
	0.step(arr.length-1, 2) do |i|
		tmp_arr = (arr[i] + arr[i+1]).to_i
		msg << tmp_arr
	end
	msg = make_msg(msg)
	return msg
end


####################################
# Start program #
####################################

puts "Caesar Cipher Encoder/Decoder, plus RSA encryption"
encode = 0
until (encode == 1) or (encode == 2) do
	print "Please enter 1 to encode, or 2 to decode: "
	encode = gets.to_i
end

print "Please enter message in plain text: "
msg = gets
# convert message to numbers 0-25
msg1 = make_num(msg, false) # for Caesar cipher

# if message is a series of numbers, then we assumed it's encoded as an RSA number sequence (groupings of 4 numbers),
# in which case we divide it into an array of four numbers each. If msg is not numeric, then convert to a number
# using make_num fxn
if(/\d+/ =~ msg)
	msg2 = Array.new # holds final string to return
	msg3 = msg.gsub(/\s/, '').strip # store temp version of string with all spaces stripped out
	0.step(msg3.strip.length-1, 4) do |i|
		tmp_arr = msg3[i] + msg3[i+1] + msg3[i+2] + msg3[i+3]
		msg2 << tmp_arr
	end
else
	msg2 = make_num(msg, true) # for RSA
end

# get algorithm
valid = false
while !valid
	print "Please enter Caesar cipher shift amount - e.g, p+3, or 2*p-5: "
	shift = gets
	# if encode = 1, we are encoding, so allow multipliers - e.g., 2*p - 3
	if encode == 1
		if /^\s*(\d*\s*\*\s*)?[a-zA-Z]\s*(\+|\-)\s*(\d+)\s*$/ =~ shift
			valid = true
		else
			puts "Invalid format, please try again."
		end
	# if encode = 2, we are decoding, so only don't allow multipliers - e.g., only p + 3, not 3*p + 3, etc.
	elsif encode == 2
		if /^\s*[a-zA-Z]\s*(\+|\-)\s*(\d+)\s*$/ =~ shift
			valid = true
		else
			puts "Invalid format, please try again."
		end
	end
end

# run Caesar cipher on numeric message to get encoded/decoded digits
trans_msg = caesar_ciph(encode, shift, msg1)
#convert final number sequence back into to string
new_msg = make_msg(trans_msg)
print "Caesar ciphered/deciphered message is ", new_msg

# for RSA, check if message is even or odd # of chars.
# if odd, we need to append a dummy number so that we get groups of 4 numbers. Only then can we run RSA encryption algorithm.
# check length of msg3 (numeric msg stripped of spaces) if it exists; otherwise, check original msg length.
if (msg3.class.to_s != "NilClass")
	if (msg3.strip.length) % 2 == 1
		msg2[-1] << "29" # ^ carat acts as spacer char - this is ASII char 94, less the 65 that was subtracted from other numbers
	end
else
	if (msg.strip.length) % 2 == 1
		msg2[-1] << "29" # ^ carat acts as spacer char - this is ASII char 94, less the 65 that was subtracted from other numbers
	end
end

# now encode RSA message
rsa_code = rsa(msg2, encode)
print "\nRSA numeric code is ", rsa_code

# print text equivalent of RSA number sequence
rsa_code = rsa_msg(rsa_code)
print "\nRSA text message is ", rsa_code

# pause before exit
puts "\nPress enter to exit."
dummy = gets