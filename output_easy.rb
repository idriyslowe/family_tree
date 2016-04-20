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
	@input_problem_array = ReadFile.read_input("/Users/igrant/CancerIQ/samples/test_samples.txt")
	@nodes_arrays = []
	@instructions_array = []
	@unique_nodes_hash = {}

	def self.output
		split_lines
		make_nodes_hash
		read_instructions
	end
	# CHECKS OUT!!! CREATES NODES, INSTRUCTIONS ARRAY, AND HOLDS ONTO NODE TOTAL
	def self.split_lines
		@input_problem_array.each do |string|
			new_array = string.split
			if new_array.length < 3
				@nodes_arrays << new_array
			else
				@instructions_array << new_array
			end
		end
		@instructions_array << @nodes_arrays.pop
		@nodes_total = @nodes_arrays.shift
	end
	# CHECKS OUT!!! INITIALIZES HASH WITH ALL NODES VALUE 0
	def self.make_nodes_hash
		new_array = @nodes_arrays.flatten.uniq
		new_array.each do |node|
			@unique_nodes_hash[node] = 0
		end
	end

	def self.end_node?(node)
		node_count = @nodes_arrays.select { |array| array.include?(node) }
		return true if node_count.length == 1
	end

	def self.read_instructions
		@instructions_array.each do |query_array|
			add_query(query_array) if query_array[0] == "add"
			max_query(query_array) if query_array[0] == "max"
		end
	end
	# DOUBLE CHECK THAT NEGATIVE VALUES ARE ADDED TO ALL IN THE CASE OF 1
	def self.add_query(array)
		# add too all if node is one
		if array[1] == "1"
			@unique_nodes_hash.each do |node, value|
				@unique_nodes_hash[node] += array[2].to_i
			end
		elsif end_node?(array[1])
		# add to only itself if node is end node...
			@unique_nodes_hash[array[1]] += array[2].to_i
		else
			@unique_nodes_hash[array[1]] += array[2].to_i
			family_tree = crawl_tree(array[1])
			family_tree.each do |node|
				@unique_nodes_hash[node] += array[2].to_i
			end
			# puts "Add query family tree #{array[1]}: #{family_tree.inspect}"
		end
		puts @unique_nodes_hash.inspect
	end
	def self.crawl_tree(start_node)
		family_tree = []
		immediate_relatives = @nodes_arrays.select { |array| array.include?(start_node) }.flatten!
		immediate_relatives.delete_if { |node| node.to_i <= start_node.to_i }
		family_tree << immediate_relatives
		family_tree << loop_through_relatives(immediate_relatives)
		family_tree.flatten
	end

	def self.loop_through_relatives(node_array, depth = 0, final_nodes = [])
		node_array.each do |current_node|
			unless end_node?(current_node) || depth >= 9
				depth += 1				
				cousins = @nodes_arrays.select { |array| array.include?(current_node) }.flatten!
				cousins.delete_if { |node| node.to_i <= current_node.to_i } unless cousins == nil
				loop_through_relatives(cousins, depth + 1, final_nodes.push(cousins))
			end
		end
		# puts "Node array #{node_array} Depth #{depth} Nodes #{final_nodes}"
		final_nodes
	end

	def self.max_query(array)
		# find all arrays that contain the first node
		puts "max"
	end
end

TreeOutput.output

