input = File.read('input.txt').split(',').map{|x| x.to_i}

min_pos = input.min
max_pos = input.max

data = (min_pos..max_pos).map do |pos|
	input.map do |x|
		(pos - x).abs
	end.sum
end

min = data.each_with_index.min
puts min
