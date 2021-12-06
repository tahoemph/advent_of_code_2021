input = File.read('input.txt').split(",").map{|x| x.to_i}

(1..80).each do |day|
	new_fish = []
	input.each_with_index do |x, index|
		input[index] -= 1
		if input[index] == -1 
			new_fish << 8
			input[index] = 6
		end
	end
	input += new_fish
end

puts input.length
