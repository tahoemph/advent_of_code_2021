input = File.read('input.txt').split("\n")

class ParseError < StandardError
    attr_reader :bad_char
    def initialize(bad_char)
        @bad_char = bad_char
    end
end

def is_open_char?(str)
    return false if str.nil? || str.empty?
    ch = str[0]
    ['(', '[', '{', '<'].include? ch
end

def is_closed_char?(str)
    return false if str.nil? || str.empty?
    ch = str[0]
    [')', ']', '}', '>'].include? ch
end

def first_char(str)
    return nil if str.nil? || str.empty?
    str[0]
end

def parse(str)
    case str[0]
    when '('
        remaining = parse(str[1..])
        while is_open_char?(remaining)
            remaining = parse(remaining)
        end
        raise ParseError.new(first_char(remaining)) unless first_char(remaining) == ')'
    when '['
        remaining = parse(str[1..])
        while is_open_char?(remaining)
            remaining = parse(remaining)
        end
        raise ParseError.new(first_char(remaining)) unless first_char(remaining) == ']'
    when '{'
        remaining = parse(str[1..])
        while is_open_char?(remaining)
            remaining = parse(remaining)
        end
        raise ParseError.new(first_char(remaining)) unless first_char(remaining) == '}'
    when '<'
        remaining = parse(str[1..])
        while is_open_char?(remaining)
            remaining = parse(remaining)
        end
        raise ParseError.new(first_char(remaining)) unless first_char(remaining) == '>'
    when ')'
        return str
    when ']'
        return str
    when '}'
        return str
    when '>'
        return str
    else
        puts "WTF"
    end
    return nil if remaining.nil? || remaining.empty?
    remaining[1..]
end

def tally_score(bad_chars)
    bad_chars.chars.filter{|c| c == ')'}.count * 3 +
    bad_chars.chars.filter{|c| c == ']'}.count * 57 +
    bad_chars.chars.filter{|c| c == '}'}.count * 1197 +
    bad_chars.chars.filter{|c| c == '>'}.count * 25137
end

bad_chars = ""
input.each do |str|
    begin
        leftover = parse(str)
        puts "incomplete" unless leftover.length == 0
    rescue ParseError => err
        puts "#{str} has bad char #{err.bad_char}"
        bad_chars += err.bad_char unless err.bad_char.nil?
    end
end

puts tally_score(bad_chars)
