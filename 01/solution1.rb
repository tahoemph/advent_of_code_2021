lines = File.read('input.txt').split("\n")
previous = lines[0].to_i
num_larger = 0
lines[1..].each do |number|
	num_larger += 1 if number.to_i > previous
	previous = number.to_i
end
puts num_larger
