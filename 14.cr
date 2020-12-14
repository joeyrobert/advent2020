lines = File.read_lines("14.txt")

# part 1
memory = {} of Int64 => Int64
ones = 0
zeros = 0

lines.each do |line|
  case line[0...3]
  when "mas"
    matches = /mask = ([X01]+)/.match(line)
    if matches
      mask = matches[1]
      ones = mask.chars.map { |x| x == '1' ? '1' : '0' }.join.to_i64(2)
      zeros = mask.chars.map { |x| x == '0' ? '0' : '1' }.join.to_i64(2)
    end
  when "mem"
    matches = /mem\[(\d+)\] = (\d+)/.match(line)
    if matches
      location = matches[1].to_i64
      value = matches[2].to_i64
      memory[location] = (value | ones) & zeros
    end
  end
end

puts memory.values.sum

# part 2
memory = {} of Int64 => Int64
floating = [] of Int64
ones = 0_i64
not_x = 0_i64
mask = ""

lines.each do |line|
  case line[0...3]
  when "mas"
    matches = /mask = ([X01]+)/.match(line)
    if matches
      mask = matches[1]
      ones = mask.chars.map { |x| x == '1' ? '1' : '0' }.join.to_i64(2)
      not_x = mask.chars.map { |x| x == 'X' ? '0' : '1' }.join.to_i64(2)
      floating = mask.chars.map_with_index { |x, index| {x, 35 - index} }.select { |x| x[0] == 'X' }.map { |x| x[1] }.reverse
    end
  when "mem"
    matches = /mem\[(\d+)\] = (\d+)/.match(line)
    if matches
      location = matches[1].to_i64
      value = matches[2].to_i64

      (2.to_i64 ** floating.size.to_i64).times do |x|
        output = 0_i64
        floating.each_with_index do |mapped_index, x_i|
          if (x & (1_i64 << x_i)) > 0
            output += (1_i64 << mapped_index)
          end
        end

        mapped_location = (location & not_x) | ones + output
        memory[mapped_location] = value
      end
    end
  end
end

puts memory.values.sum
