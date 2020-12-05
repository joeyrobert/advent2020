def bsp(min, max, str)
  range = max + 1
  str.chars.each do |ch|
    if ch == 'F' || ch == 'L'
      max -= range // 2
    elsif ch == 'B' || ch == 'R'
      min += range // 2
    end
    range //= 2
  end

  min
end

def seat_id(code)
  row = bsp(0, 127, code[...7])
  col = bsp(0, 7, code[-3..])
  row * 8 + col
end

# part 1
max = 0
File.each_line("05.txt") do |code|
  x = seat_id(code)
  if x > max
    max = x
  end
end

puts max

# part 2
ids = Set.new(0...(8*128))
File.each_line("05.txt") do |code|
  ids.delete(seat_id(code))
end

ids.each do |id|
  before = id - 8
  after = id + 8
  if before > 0 && !ids.includes?(before) && after < 1024 && !ids.includes?(after)
    puts id
  end
end
