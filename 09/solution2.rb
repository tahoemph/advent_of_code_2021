require 'set'

input = File.read('input.txt').split("\n")

MAX_X = input[0].length
MAX_Y = input.length

def is_lowest_point?(input, pt_x, pt_y)
    valid_coords([pt_y, pt_x]).map{ |coord| input[coord[0]][coord[1]].to_i > input[pt_y][pt_x].to_i }.all?
end

def already_in_basin?(basins, x, y)
    basins.each do |basin|
        return true if basin.include?([y, x])
    end
    false
end

def valid_coords(coords)
    x = coords[1]
    y = coords[0]
    surrounding = [[y - 1, x], [y, x - 1], [y, x + 1], [y + 1, x]]
    surrounding.select do |coords|
        pt_y = coords[0].to_i
        pt_x = coords[1].to_i
        next false if pt_y.negative? || pt_y >= MAX_Y
        next false if pt_x.negative? || pt_x >= MAX_X

        true
    end
end

def build_basin(input, x, y, existing, offset = 0)
    pt = input[y][x].to_i
    coords_to_check = valid_coords([y, x])

    existing += [[y, x]]
    coords_to_check.each do |coord|
        next if already_in_basin?([existing], coord[1], coord[0])

        new_pt = input[coord[0]][coord[1]].to_i
        existing += build_basin(input, coord[1], coord[0], existing, offset + 1) if new_pt >= pt && new_pt != 9
    end
    existing.uniq
end

low_point_map = Array.new(MAX_Y) { Array.new(MAX_X, 0)}
(0..MAX_X - 1).each do |x|
    (0..MAX_Y - 1).each do |y|
        pt = input[y][x].to_i
        next if pt == 9
        low_point_map[y][x] = 1 if is_lowest_point?(input, x, y)
    end
end

basins = []
(0..MAX_X - 1).each do |x|
    (0..MAX_Y - 1).each do |y|
        puts "#{y} #{x}"
        next if low_point_map[y][x].zero?
        next if already_in_basin?(basins, x, y)
        basins << build_basin(input, x, y, [])
        puts "done #{x} #{y}"
    end
end

puts basins.sort_by{|x| -1*x.length}.slice(0, 3).map{|x| x.length}.inject(:*)
