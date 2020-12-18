lines = File.read_lines("18.txt").map { |line| line.gsub(/ /, "") }

# part 1
def sum_line(line, start = 0)
  i = start
  operator : Char | Nil = nil
  value = 0_i64

  while i < line.size
    case line[i]
    when .to_i64?
      if operator.nil?
        value = line[i].to_i64
      elsif operator == '*'
        value *= line[i].to_i64
      elsif operator == '+'
        value += line[i].to_i64
      end
      i += 1
    when '('
      sub_output, sub_offset = sum_line(line, i + 1)
      i = sub_offset

      if operator.nil?
        value = sub_output
      elsif operator == '*'
        value *= sub_output
      elsif operator == '+'
        value += sub_output
      end
    when ')'
      return {value, i + 1}
    when '*'
      operator = '*'
      i += 1
    when '+'
      operator = '+'
      i += 1
    end
  end

  {value, i}
end

puts lines.map { |line| sum_line(line)[0] }.sum

# part 2
def bracket_pluses(str)
  pluses = str.count('+')

  pluses.times do |i|
    plus_locations = str.chars.map_with_index { |ch, idx| {ch, idx} }.select { |ch, idx| ch == '+' }.map { |ch, idx| idx }
    plus = plus_locations[i]

    # go left then right
    depth = 0
    left = plus - 1
    loop do
      case str.chars[left]
      when .to_i64?
        if depth == 0
          break
        end
      when ')'
        depth += 1
      when '('
        depth -= 1
        if depth == 0
          break
        end
      end
      left -= 1
    end

    depth = 0
    right = plus + 1
    loop do
      case str.chars[right]
      when .to_i64?
        if depth == 0
          break
        end
      when '('
        depth += 1
      when ')'
        depth -= 1
        if depth == 0
          break
        end
      end
      right += 1
    end

    str = str.insert(right + 1, ')').insert(left, '(')
  end

  str
end

puts lines.map { |line| sum_line(bracket_pluses(line))[0] }.sum
