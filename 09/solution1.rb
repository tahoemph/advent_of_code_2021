input = File.read('input.txt').split("\n")

MAX_X = input[0].length
MAX_Y = input.length

def is_lowest_point?(input, pt_x, pt_y)
    surrounding = [[pt_y - 1, pt_x], [pt_y, pt_x - 1], [pt_y, pt_x + 1], [pt_y + 1, pt_x]]
    coords_to_check = surrounding.select do |coords|
        y = coords[0].to_i
        x = coords[1].to_i
        next false if y.negative? || y >= MAX_Y
        next false if x.negative? || x >= MAX_X

        true
    end

    coords_to_check.map{ |coord| input[coord[0]][coord[1]].to_i > input[pt_y][pt_x].to_i }.all?
end

risks = []
(0..MAX_X - 1).each do |x|
    (0..MAX_Y - 1).each do |y|
        pt = input[y][x].to_i
        risks << pt.to_i + 1 if is_lowest_point?(input, x, y)
    end
end

puts risks.sum