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
	def self.add_query(array)
		if array[1] == "1"
			@unique_nodes_hash.each do |node, value|
				@unique_nodes_hash[node] += array[2].to_i
			end
		elsif end_node?(array[1])
			@unique_nodes_hash[array[1]] += array[2].to_i
		else
			@unique_nodes_hash[array[1]] += array[2].to_i
			family_tree = crawl_tree(array[1])
			family_tree.each do |node|
				@unique_nodes_hash[node] += array[2].to_i
			end
		end
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
		final_nodes
	end

	def self.max_query(array)
		full_path = []
		higher_node = [array[1].to_i, array[2].to_i].max.to_s
		lower_node = [array[1].to_i, array[2].to_i].min.to_s
		full_path << lower_node
		full_path << higher_node
		full_path << higher_node_crawl(lower_node, higher_node)
		full_path << higher_node_crawl(higher_node, lower_node)
		puts "Full path #{full_path}"
		# if there's a duplicate in a number other than 1, get rid of it. its extra
	end

	def self.higher_node_crawl(start_node, other_node, full_path = [])
		if !full_path.include?(start_node) || !full_path.include?("1")
			first_low_neighbor = @nodes_arrays.select { |array| array.include?(other_node) }.flatten!
			first_low_neighbor.delete_if { |node| node.to_i >= other_node.to_i } if first_low_neighbor != nil
			higher_node_crawl(start_node, first_low_neighbor[0], full_path.push(first_low_neighbor)) if first_low_neighbor != nil
		end
		puts "Start node #{start_node} Other node #{other_node} Full path\n#{full_path}"
		full_path
	end

	def self.
end

TreeOutput.output

