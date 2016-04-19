class ReadFile
	def self.read_input(file_path)
	file = file_path
	file_lines = []
	fileObj = File.new(file, "r")
		while (line = fileObj.gets)
	 		file_lines << line
		end
		file_lines
	end
end

class TreeOutput
	attr_accessor :instructions_array, :nodes_array
	@input_problem_array = ReadFile.read_input("/Users/igrant/CancerIQ/samples/input01.txt")
	@nodes_array = []
	@instructions_array = []
	@unique_nodes_hash = {}
	@path_hash = {}
	@final_path = []

	def self.output
		split_lines
		make_nodes_hash
		find_common_node
		end_nodes
		read_instructions
	end
	# CHECKS OUT!!! CREATES NODES AND INSTRUCTIONS ARRAY
	def self.split_lines
		@input_problem_array.each do |string|
			new_array = string.split
			if new_array.length < 3
				@nodes_array << new_array
			else
				@instructions_array << new_array
			end
		end
		@instructions_array << @nodes_array.pop
	end
	# CHECKS OUT!!! INITIALIZES HASH WITH ALL NODES VALUE 0
	def self.make_nodes_hash
		new_array = @nodes_array.flatten.uniq
		new_array.each do |node|
			@unique_nodes_hash[node] = 0
		end
	end
	# CHECKS OUT!!! MAKES HASH WITH NODE AND EVERY ONE IT TOUCHES
	def self.find_common_node
		@unique_nodes_hash.each_key do |node|
			new_array = @nodes_array.select { |array| array.include?(node) }
			node_and_relatives = new_array.flatten.uniq
			node_relatives = node_and_relatives.delete(node)
			@path_hash[node] = node_and_relatives
		end
	end
	# CHECKS OUT!!! CALLS MAX AND ADD WHEN INSTRUCTED
	def self.read_instructions
		@instructions_array.each do |query_array|
			add_query(query_array) if query_array[0] == "add"
			max_query(query_array) if query_array[0] == "max"
		end
	end
	# DOUBLE CHECK THAT NEGATIVE VALUES ARE ADDED TO ALL IN THE CASE OF 1
	def self.add_query(array)
		# leave final path here so it only deletes when you call it
		@final_path = []
		if array[1] == "1"
			@unique_nodes_hash.each { |node, value| value += array[2].to_i }
		else
			@unique_nodes_hash[array[1]] += array[2].to_i
			final_path = find_path_to_end(array[1])
		end
	end
	# DETERMINE END NODES! ONLY TOUCH ONE OTHER NODE. ITS CLOSEST PARENT DOESN'T HAVE CHILDREN
	def self.end_nodes
		@end_nodes = @path_hash.select { |node, relatives| relatives.length == 1 && node.to_i > 1 }
	end
	# START NODE IS ALREADY AFFECTED ABOVE. DONT FORGET TO KEEP STARTING RELATIVES!
	# def self.find_path_to_end(start_node)
	# 	puts "Start node #{start_node}"
	# 	# !!start_node = 2
	# 	@final_path = []		
	# 	starting_relatives = @path_hash.select { |node, relatives| relatives.include?(start_node) && node.to_i > start_node.to_i }
	# 	# !!starting_relatives =  {"4"=>["2", "8"], "5"=>["2"]}
	# 	@final_path << starting_relatives.keys
	# 	starting_relatives.values.each do |relatives|
	# 	# !!relatives = ["2", "8"] ["2"]
	# 		relatives.each do |relative|
	# 			# !!relative = "2", "8", "2" ignoring all twos below
	# 			@final_path << @path_hash[relative] unless relative == start_node
	# 			# final_path = [["4", "5"], ["4", "9"]]
	# 			puts "relative #{relative} and it's values #{@path_hash[relative]}. Final path\n#{@final_path.inspect}"
	# 		end
	# 	end
	# 	# continue retrieving node values until you run out
	# end

	def self.find_path_to_end(start_node)
		last_crawl = []		
		starting_relatives = @path_hash.select { |node, relatives| relatives.include?(start_node) && node.to_i > start_node.to_i }
		@final_path << starting_relatives.keys
		starting_relatives.values.each do |relatives|
			relatives.each do |relative|
				last_crawl << @path_hash[relative] unless relative == start_node
				@final_path << @path_hash[relative] unless relative == start_node
			end
		end
		last_crawl.flatten!
		last_crawl.each do |node|
			find_path_to_end(node)
		end
		full_path = @final_path.flatten
	end	

	def self.sub_path(sub_array)
		temp_array = []
		flattened_array = sub_array.flatten	
		flattened_array.each do |node|
			temp_array << @path_hash[node]
		end
		temp_array
	end
	
	# CAN WE COMBINE THIS WITH MAKE_PATHS
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
		max = values.values.max_by { |value| value }
		# puts max
	end
end

TreeOutput.output

