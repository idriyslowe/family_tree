class TreeOutput
	@input00 = [["5"], ["1 2"], ["2 3"], ["2 4"], ["5 1"], ["6"], ["add 4 30"], ["add 5 20"], ["max 4 5"], ["add 2 -20"], ["max 4 5"], ["max 3 4"]]
	@nodes_array = []
	@instructions_array = []
	@unique_nodes_hash = {}
	@path_hash = {}

	def self.output
		split_arrays
		make_nodes_hash
		find_common_node
		read_instructions
	end
	def self.split_arrays
		@input00.each do |array|
			new_array = array[0].split
			if new_array.length < 3
				@nodes_array << new_array
			else
				@instructions_array << new_array
			end
		end
		@instructions_array << @nodes_array.pop
	end

	def self.make_nodes_hash
		new_array = @nodes_array.flatten.uniq
		new_array.each do |node|
			@unique_nodes_hash[node] = 0
		end
	end

	def self.find_common_node
		@unique_nodes_hash.each_key do |node|
			new_array = @nodes_array.select { |array| array.include?(node) }
			node_and_relatives = new_array.flatten.uniq
			node_relatives = node_and_relatives.delete(node)
			@path_hash[node] = node_and_relatives
		end
	end

	def self.read_instructions
		@instructions_array.each do |array|
			add_query(array) if array[0] == "add"
			max_query(array) if array[0] == "max"
		end
	end
	def self.add_query(array)
		@unique_nodes_hash[array[1]] += array[2].to_i
		node_relatives = @path_hash.select { |node, relatives| relatives.include?(array[1]) }
		if node_relatives.length > 1
			node_relatives.each do |node, relatives|
				if relatives.length == 1
					@unique_nodes_hash[node] += array[2].to_i
				else
					relatives.each do |node|
						@unique_nodes_hash[node] += array[2].to_i if @path_hash[node].include?(array[1])
					end
				end	
			end
		end
	end

	def self.sub_path(sub_array)
		temp_array = []
		flattened_array = sub_array.flatten	
		flattened_array.each do |node|
			temp_array << @path_hash[node]
		end
		temp_array
	end
	
	def self.max_query(array)
		make_paths(array)
	end

	def self.make_paths(array)
		path_array = array[1..2]
		temp_array = []
		path_array.each do |node|
			path_array = path_array.flatten
			temp_array << @path_hash[node]
		end
		if temp_array.uniq.length == temp_array.length
			path_array << sub_path(temp_array)
		else
			temp_array << array[1..2]
		end
		path_array << temp_array
		ugh = path_array.flatten
		ultimate_path = ugh.select { |node| ugh.count(node) > 1}.uniq
		calculate_max(ultimate_path)
	end

	def self.calculate_max(ultimate_path)
		values = @unique_nodes_hash.select { |node, value| ultimate_path.include?(node) }
		max = values.values.max_by { |value| value}
		puts max
	end
end

TreeOutput.output

# Create graph
# 1. read file line by line, ignoring empty lines OR take input as an array of an array of string for now like the file read would produce
# 2. Split and comma separated arrays: DONE
# 3. Process arrays differently based on their length: DONE
# 	Node lines length == 2
# 	Instructions length == 3
#   The Node that is last OR not found in any other node array is the query quantity number:
# 4. Make hash (default 0) of flattened array for output: DONE
	# Flatten array and pull out all uniques
# 5. Make path arrays out of all paths by joining arrays with common numbers, omit non-unique numbers:
	# Make array initiating w/end nodes
	# Add the arrays from those nodeses path hashes
	# CHECK for any duplicate nodes
	# If not, retrieve relative nodes arrays and check again
	# For each key's flatten, remove unique, shovel into path array

# Create output
# 1. Iterate through split array reading instructions
	# If begins with "add", add second number to value in hash.
	# Find nodes that are only related to one other node
	# OR
	# Find nodes child nodes (in other hashes & others are in its hash)
	# If begins with "max", read values of all nodes in path from hash to find highest value. Output node.
	# 	For each node, save and read value from the hash.
	# 	Calculate your max from the saved values.
	# 	Output that

# add occurs for itself & all child nodes for non-end nodes
# max is looking for max value of nodes on path from a to b
# ONLY OUTPUTTING MAX VALUES. adding is a quiet step

# input00 easy
# 5
# 1 2
# 2 3
# 2 4
# 5 1
# 6
# add 4 30
# add 5 20
# max 4 5
# add 2 -20
# max 4 5
# max 3 4

# output00 easy
# 30
# 20
# 10