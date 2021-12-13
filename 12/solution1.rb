input = File.read('input.txt').split("\n").map{|x| x.split('-')}

class Node
	attr_reader :name
	attr_reader :connections

	def initialize(name)
		@name = name
		@connections = []
	end

	def connect(node)
		@connections << node unless @connections.include?(node)
	end
end

class Graph
	attr_reader :start
	attr_reader :end
	attr_reader :nodes

	def initialize(input)
		@start = Node.new("start")
		@end = Node.new("end")
		@nodes = []
		input.each do |line|
			start_node = find_or_create_node(line[0])
			end_node = find_or_create_node(line[1])
			start_node.connect(end_node)
			end_node.connect(start_node)
		end	
	end

	def find_or_create_node(name)
		if name == "start"
			return @start
		elsif name == "end"
			return @end
		else
			existing = @nodes&.find{|node| node.name == name}
			return existing if existing
			node = Node.new(name)
			@nodes << node
			node
		end
	end
	
	def find_paths
		paths = [[@start]]
		finished = []
		while !paths.empty?
			new_paths = []
			paths.each do |path|
				paths_to_consider = path[-1].connections.map do |node|
					path + [node]
				end
				paths_to_consider.filter! do |path|
					next true if path[-1].name == path[-1].name.upcase
					!path[0..-2].include?(path[-1])
				end
				new_paths += paths_to_consider
			end

			paths = new_paths.filter{|path| path[-1] != @end}
			finished += new_paths.filter{|path| path[-1] == @end}
		end

		finished.filter do |path|
			smalls = path.map{|node| node.name }.select{|name| name[0] == name[0].downcase }
			ans = smalls[1..].each_with_index.all? do |element, index|
				element != smalls[index] # index is off of smalls + 1
			end
			ans
		end
	end

	def dump
		nodes = [@start] + @nodes + [@end]
		nodes.each do |node|
			connections = node.connections.map{|connection| connection.name}
			puts "#{node.name} -> #{connections}"
		end
		nil
	end

	def dump_path(path)
		path_str = path.map do |node|
			"#{node&.name}"
		end.join(' -> ')
		puts path_str
	end

	def dump_paths(paths)
		paths.each do |path|
			dump_path(path)
		end
		nil
	end
end

GRAPH = Graph.new(input)

puts GRAPH.find_paths.length