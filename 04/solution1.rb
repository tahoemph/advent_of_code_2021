require 'pry'

def get_board(lines)
	board = []
	lines.each do |line|
		board << line.split(' ').map{|x| {used: false, value: x}}
	end
	board
end

def mark_value(boards, value)
	boards.each do |board|
		(0..4).each do | row|
			(0..4).each do |col|
				board[row][col][:used] = true if board[row][col][:value] == value
			end
		end
	end
end

def winner?(board)
	row_won = (0..4).map{|row| board[row].map{|x| x[:used]}.all?}.any?
	col_won = (0..4).map{|col| board.transpose[col].map{|x| x[:used]}.all?}.any?
	row_won || col_won
end

lines = File.read('input.txt').split("\n")

input = lines[0].split(",")

boards = []
lines[2..].each_slice(6) do |lines|
	boards << get_board(lines[0..4])
end

input.each do |x|
	mark_value(boards, x)
	boards.each do |board|
		if winner? board
			unmarked = board.flatten.select{|x| !x[:used]}.map{|x| x[:value].to_i}.inject(:+)
			puts unmarked.to_i * x.to_i
			exit!
		end
	end
end

