input = File.read('input.txt').split("\n")

class Counter
	attr_reader :level
	def initialize(level = 0)
		@level = level
	end

	def inc
		@level += 1
	end
end

class Octopus
	attr_reader :level
	attr_reader :flashed

	def initialize(level, counter = nil)
		@level = level.to_i
		@flashed = false
		@counter = counter
	end

	def bump
		@level += 1
	end

	def has_flashed?
		@flashed
	end

	def flash
		@counter.inc unless !@counter || @flashed
		@flashed = true
	end

	def reset_flash
		@level = 0 if @flashed
		@flashed = false
	end
end

def step(octopuses)
	# Initialization and reset (step 3)
	octopuses.each_with_index do |row|
		row.each_with_index do |octopus|
			octopus.reset_flash
		end
	end

	# Step 1 bump everybody by 1
	octopuses.each do |row|
		row.each_with_index do |octopus|
			octopus.bump
		end
	end

	loop do
		# Step 2 propagate until there is no more energy to consume
		start_flashed = COUNTER.level
		octopuses.each_with_index do |row, row_index|
			row.each_with_index do |octopus, col_index|
				# If we've flashed but not consumed that energy to that
				if octopus.level > 9 && !octopus.has_flashed?
					octopuses[row_index - 1]&.[](col_index - 1)&.bump unless row_index == 0 || col_index == 0
					octopuses[row_index - 1]&.[](col_index)&.bump unless row_index == 0
					octopuses[row_index - 1]&.[](col_index + 1)&.bump unless row_index == 0 
					octopuses[row_index]&.[](col_index + 1)&.bump
					octopuses[row_index + 1]&.[](col_index + 1)&.bump
					octopuses[row_index + 1]&.[](col_index)&.bump
					octopuses[row_index + 1]&.[](col_index - 1)&.bump unless col_index == 0
					octopuses[row_index]&.[](col_index - 1)&.bump unless col_index == 0
					octopus.flash
				end
			end
		end
		break if start_flashed == COUNTER.level
	end
end

def output_octopuses(octopuses)
	octopuses.each do |row|
		output = ''
		row.each do |octopus|
			output += octopus.level > 9 ? 'T' : "#{octopus.level}"
		end
		puts output
	end
end

COUNTER = Counter.new

octopuses = Array.new(input.length) { Array.new(input[0].length) }
input.each_with_index do |row, row_index|
	row.chars.each_with_index do |octopus, col_index|
		octopuses[row_index][col_index] = Octopus.new(octopus, COUNTER)
	end
end

(1..).each do |step_number|
	last = COUNTER.level
	step(octopuses)
	if COUNTER.level - last == input.length * input[0].length
		puts "syncronized at #{step_number}"
		break
	end
end
