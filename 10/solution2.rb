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

def first_char(str)
    return "" if str.nil? || str.empty?
    str[0]
end

def parse(str, fixups)
    remaining = str
    while is_open_char?(remaining)
        remaining = parse_expr(remaining, fixups)
    end
    remaining
end

def parse_expr(str, fixups)
    case str[0]
    when '('
        remaining = parse(str[1..], fixups)
        if first_char(remaining).empty?
            fixups << ')'
            return nil
        end
        raise ParseError.new(first_char(remaining)) unless first_char(remaining) == ')'
    when '['
        remaining = parse(str[1..], fixups)
        if first_char(remaining).empty?
            fixups << ']'
            return nil
        end
        raise ParseError.new(first_char(remaining)) unless first_char(remaining) == ']'
    when '{'
        remaining = parse(str[1..], fixups)
        if first_char(remaining).empty?
            fixups << '}'
            return nil
        end
        raise ParseError.new(first_char(remaining)) unless first_char(remaining) == '}'
    when '<'
        remaining = parse(str[1..], fixups)
        if first_char(remaining).empty?
            fixups << '>'
            return nil
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
    end
    return "" if remaining.nil? || remaining.empty?
    remaining[1..]
end

class ScoreState
    attr_reader :score
    SCORE_MAP = {
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4
    }.freeze

    def initialize
        @score = 0
    end

    def update(val)
        begin
            @score = @score * 5 + SCORE_MAP[val]
        rescue => err
            puts "bad #{val}"
            puts
        end
    end
end

bad_chars = ""
score_list = []
input.each do |str|
    begin
        fixups = []
        leftover = parse(str, fixups)
        if !fixups.empty?
            score = ScoreState.new
            fixups.each do |c|
                score.update(c)
            end
            score_list << score
        end
    rescue ParseError => err
        puts "#{str} has bad char #{err.bad_char}"
    end
end

scores = score_list.sort_by{|x| x.score}
puts scores[scores.length / 2].score
