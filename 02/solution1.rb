lines = File.read('input.txt').split("\n").map {|x| x.split(' ')}
horizontal = 0
depth = 0
lines.each do |command, argument|
	case command
		when 'forward'
			horizontal += argument.to_i
		when 'down'
			depth += argument.to_i
		when 'up'
			depth -= argument.to_i
		else
			puts 'what ' + command
	end
end
puts horizontal * depth

