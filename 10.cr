nums = File.read_lines("10.txt").map(&.to_i32)

# part 1
source_jolt = 0
device_jolt = nums.max + 3

nums << 0
nums << device_jolt
nums.sort!

# part 1
ones = 0
threes = 0
i = 1
while i < nums.size
  diff = nums[i] - nums[i - 1]

  if diff == 1
    ones += 1
  elsif diff == 3
    threes += 1
  end
  i += 1
end

p ones * threes

# part 2
cache = {} of Tuple(Int32, Int32) => Int64

def recurse(nums, cache, jolt, i)
  if cache[{jolt, i}]?
    cache[{jolt, i}]
  elsif nums.size == i
    1
  else
    sum = 0_i64
    i.upto(i + 3) do |x|
      if x < nums.size && nums[x] <= jolt + 3
        sum += recurse(nums, cache, nums[x], x + 1)
      end
    end
    cache[{jolt, i}] = sum
    sum
  end
end

puts recurse(nums, cache, 0, 1)
