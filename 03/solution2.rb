lines = File.read('input.txt').split("\n")

def common(numbers, index)
	numbers.select{|x| x[index] == '1'}.length >= (numbers.length / 2.0) ? '1' : '0'
end

oxygen = lines
(0..11).each do |num|
	common_value = common(oxygen, num).to_s
	oxygen = oxygen.select{|x| x[num] == common_value}
	break if oxygen.length == 1
end

co2 = lines
(0..11).each do |num|
	least_common_value = common(co2, num) == '1' ? '0' : '1'
	co2 = co2.select{|x| x[num] == least_common_value}
	break if co2.length == 1
end

raise "incorrect number of values" if oxygen.length != 1  || co2.length != 1

puts oxygen[0].to_i(2) * co2[0].to_i(2)
