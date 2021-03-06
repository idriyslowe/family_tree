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

require 'set'

class Node
	attr_accessor :name, :relatives, :value
	def initialize(name)
		@name = name
		@relatives = Set.new
		@value = 0
	end
end

class Graph
	@nodes_arrays = []
	@queries_array = []
	@node_collection = []

	def self.output(file_path)
		@graph = ReadFile.read_input(file_path)
		split_lines
		make_node_collection
		update_node_relatives
		read_queries
	end
	def self.split_lines
		@graph.each do |string|
			string_array = string.split
			if string_array.length < 3
				@nodes_arrays << string_array
			else
				@queries_array << string_array
			end
		end
		@queries_array.push(@nodes_arrays.pop)
		@nodes_total = @nodes_arrays.shift
	end
	def self.find_relatives(node)
		@nodes_arrays.select { |array| array.include?(node) }
	end
	def self.make_node_collection
		unique_nodes = @nodes_arrays.flatten.uniq
		unique_nodes.each do |node|
			current_node = Node.new(node)
			@node_collection << current_node
		end
	end
	def self.update_node_relatives
		@node_collection.each do |node|
			relatives = find_relatives(node.name).flatten.uniq
			relatives.delete(node)
			relatives.each { |relative| node.relatives << find_node(relative) }		
		end
	end
	def self.end_node?(node)
		relatives = find_relatives(node)
		return true if relatives.length == 1
	end
	def self.read_queries
		@queries_array.each do |query_array|
			add_query(query_array) if query_array[0] == "add"
			max_query(query_array) if query_array[0] == "max"
		end
	end
	def self.find_node(name)
		@node_collection.find {|node| node.name == name }
	end
	def self.add_query(array)
		if array[1] == "1"
			@node_collection.each do |node|
				node.value += array[2].to_i
			end
		elsif end_node?(array[1])
			node = find_node(array[1])
			node.value += array[2].to_i
		else
			family_tree = []
			root = find_node("1")
			node = find_node(array[1])
			tree_search = BreadthSearch.new(node)
			parents = tree_search.shortest_path_to(root)
			family_tree << find_descendants(node, parents)
			family_tree.flatten!
			family_tree.each do |node|
				node.value += array[2].to_i
			end
		end
	end
	def self.find_descendants(start_node, parents_array)
		visited = [start_node]
		queue = []
		queue << start_node
		while queue.any?
			current_node = queue.shift
			current_node.relatives.each do |relative|
				next if visited.include?(relative) || parents_array.include?(relative)
				queue << relative
				visited << relative
				current_node = relative
			end
		end
		visited
	end	
	def self.max_query(array)
		values = []
		source_node = find_node(array[1])
		terminal_node = find_node(array[2])
		search = BreadthSearch.new(source_node)
		family_tree = search.shortest_path_to(terminal_node)
		family_tree.each do |node|
			values << node.value
		end
		puts values.max
	end
end

class BreadthSearch
	def initialize(source_node)
		@source_node = source_node
		@visited = []
		@edge_to = {}

		breadth_first_search(source_node)
	end
	def shortest_path_to(node)
    return unless has_path_to?(node)
    path = []

    while(node != @source_node) do
      path.unshift(node)
      node = @edge_to[node]
    end

    path.unshift(@source_node)
	end
	private
	def breadth_first_search(node)
    queue = []
    queue << node
    @visited << node

    while queue.any?
	    current_node = queue.shift
	    current_node.relatives.each do |adjacent_node|
	      next if @visited.include?(adjacent_node)
	      queue << adjacent_node
	      @visited << adjacent_node
	      @edge_to[adjacent_node] = current_node
	    end
	  end
	end
	def has_path_to?(node)
	    @visited.include?(node)
	end
end

Graph.output("/Users/igrant/family_tree/challenges_2/input_hard.txt")

