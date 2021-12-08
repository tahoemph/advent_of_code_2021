input = File.read('input.txt').split("\n").map{|x| x.split('|')}.map{|x| [x[0].split(' '), x[1].split(' ')]}

puts input.map{|x| x[1].filter{|x| [2, 4, 3, 7].include?(x.length)}}.flatten.length

