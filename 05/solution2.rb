commands = File.read('input.txt').split("\n").map{|line| line.split("->").map{|x| x.split(',').map{|x| x.to_i}}}

max_col = commands.map{|x| [x[0][0], x[1][0]].max}.max
max_row = commands.map{|x| [x[0][1], x[1][1]].max}.max

floor_map = Array.new(max_row + 1) { Array.new(max_col + 1, 0) }

commands.each do |from, to|
	if from[0] == to[0]
		rows = [from[1], to[1]].sort
		(rows[0]..rows[1]).each do |row|
			floor_map[row][from[0]] += 1
		end
	elsif from[1] == to[1]
		cols = [from[0], to[0]].sort
		(cols[0]..cols[1]).each do |col|
			floor_map[from[1]][col] += 1
		end
	else	
		coords = [from, to].sort_by{|x| x[1]}
		dir = coords[0][0] < coords[1][0] ? 1 : -1
		col = coords[0][0]
		(coords[0][1]..coords[1][1]).each do |row|
			floor_map[row][col] += 1
			col += dir
		end
	end
end

puts floor_map.flatten.select{|x| x > 1}.length
