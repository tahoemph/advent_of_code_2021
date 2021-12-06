lines = File.read('input.txt').split("\n")
common = Array.new(12, 0)
total = lines.length
lines.each do |bits|
	bits.split('').each_with_index do |bit, index|
		common[index] += 1 if bit == '1'
	end
end
gamma = common.map{|num| num > total / 2 ? 1 : 0}.join('').to_i(2)
epsilon = common.map{|num| num < total / 2 ? 1 : 0}.join('').to_i(2)
puts gamma * epsilon
