input = File.read('input.txt').split(",").map{|x| [x.to_i, 1]}

(1..256).each do |day|
	num_new_fish = 0
	input.each_with_index do |x, index|
		input[index][0] -= 1
		if input[index][0] == -1 
			num_new_fish += input[index][1]
			input[index][0] = 6
		end
	end
	input += [[8, num_new_fish]] if num_new_fish > 0
end

puts input.map{|x| x[1]}.flatten.sum
