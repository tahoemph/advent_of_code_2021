lines = File.read('input.txt').split("\n").map{|x| x.to_i}
previous = lines[0..2].sum
num_larger = 0;
(1..lines.length - 2).each do |index|
	sum = lines[index..index+2].sum
	num_larger += 1 if sum > previous
	previous = sum
end
puts num_larger
