nums = File.read("15.txt").split(",").map(&.to_i)
spoken = {} of Int32 => Array(Int32)
counts = {} of Int32 => Int32

30000000.times do |i|
  if !nums[i]?
    if (counts[nums[i - 1]]? == 1)
      nums << 0
    else
      nums << (i - spoken[nums[i - 1]][-2] - 1)
    end
  end

  spoken[nums[i]] ||= [] of Int32
  spoken[nums[i]] << i
  counts[nums[i]] ||= 0
  counts[nums[i]] += 1
end

# part 1
puts nums[2020 - 1]

# part 2
puts nums[-1]
