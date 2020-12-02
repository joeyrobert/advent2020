# part 1
valid = 0

File.each_line("02.txt") do |line|
  rule, password = line.split(": ")

  range, letter = rule.split(' ')
  min, max = range.split('-').map(&.to_i)
  count = password.count(letter)

  is_valid = count >= min && count <= max

  if is_valid
    valid += 1
  end
end

puts valid

# part 2
valid = 0

File.each_line("02.txt") do |line|
  rule, password = line.split(": ")

  range, letter = rule.split(' ')
  min, max = range.split('-').map { |x| x.to_i - 1 }
  letter = letter[0]
  is_valid = (password[min] == letter || password[max] == letter) && !(password[min] == letter && password[max] == letter)

  if is_valid
    valid += 1
  end
end

puts valid
