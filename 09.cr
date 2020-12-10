nums = File.read_lines("09.txt").map(&.to_i64)

# part 1
i = 25
invalid_num = 0_i64
while i < nums.size
  preamble = nums[(i - 25)...i]
  good = false
  preamble.combinations(2).each do |(a, b)|
    if a + b == nums[i]
      good = true
      break
    end
  end

  if !good
    invalid_num = nums[i]
    break
  end

  i += 1
end

puts invalid_num

# part 2
i = 0
while i < nums.size
  j = i + 2
  while j < nums.size
    sum = nums[i...j].sum
    if sum == invalid_num
      puts nums[i...j].min + nums[i...j].max
      exit
    elsif sum > invalid_num
      break
    end
    j += 1
  end
  i += 1
end
