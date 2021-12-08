require('set')
input = File.read('input.txt').split("\n").map{|x| x.split('|')}.map{|x| [x[0].split(' '), x[1].split(' ')]}

def value_mapped(seg_map, value)
	value.chars.map do |c|
		seg_map[c.to_sym]
	end
end

DIGIT_MAP = {
	'abcefg': 0,
	'cf': 1,
	'acdeg': 2,
	'acdfg': 3,
	'bcdf': 4,
	'abdfg': 5,
	'abdefg': 6,
	'acf': 7,
	'abcdefg': 8,
	'abcdfg': 9
}

def digit_map(value)
	DIGIT_MAP[value.sort.join('').to_sym]
end

vals = []
input.map do |x|
	# map from chars in signal to mapped values in 7 seg display
	seg_map = { a: nil, b: nil, c: nil, d: nil, e: nil, f: nil, g: nil }
	signal = x[0]

	elem = signal.filter{|x| x.length == 2}[0]
	seg_map[elem[0].to_sym] = 'c'
	seg_map[elem[1].to_sym] = 'f'
	# Order to be cleaned up later

	elem = signal.filter{|x| x.length == 3}[0]
	useful = elem.chars.filter{|c| ![seg_map.key('c').to_s, seg_map.key('f').to_s].include?(c)}
	seg_map[useful[0].to_sym] = 'a'

	elem5s = signal.filter{|x| x.length == 5}
	elem4 = signal.filter{|x| x.length == 4}[0]
	remaining = Set.new(elem5s[0].chars) & Set.new(elem5s[1].chars) & Set.new(elem5s[2].chars) - elem4.chars - seg_map.key('a').to_s.chars
	seg_map[remaining.first.to_sym] = 'g'

	remaining = Set.new(elem5s[0].chars) & Set.new(elem5s[1].chars) & Set.new(elem5s[2].chars) - seg_map.key('a').to_s.chars - seg_map.key('g').to_s.chars
	seg_map[remaining.first.to_sym] = 'd'

	known_chars = [seg_map.key('a'), seg_map.key('c'), seg_map.key('d'), seg_map.key('f'), seg_map.key('g')].map{|x| x.to_s}
	elem4 = signal.filter{|x| x.length == 4}[0]
	remaining = elem4.chars - known_chars 
	seg_map[remaining[0].to_sym] = 'b'

	known_chars += seg_map.key('b').to_s.chars
	elem8 = signal.filter{|x| x.length == 7}[0]
	remaining = elem8.chars - known_chars 
	seg_map[remaining[0].to_sym] = 'e'

	# Flip around c and f if we guessed incorrect initially.
	elem2 = elem5s.filter{|x| x.chars.include?(seg_map.key('e').to_s)}[0]
	if !elem2.chars.include?(seg_map.key('c').to_s)
		ckey = seg_map.key('c')
		fkey = seg_map.key('f')
		cval = seg_map[ckey]
		seg_map[ckey] = seg_map[fkey]
		seg_map[fkey] = cval
	end

	values = x[1]
	result = ''
	values.each do |x| 
		mapped = value_mapped(seg_map, x)
		result += digit_map(mapped).to_s
	end
	vals << result.to_i
end

puts vals.sum