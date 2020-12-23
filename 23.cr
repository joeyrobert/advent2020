input = "389547612"
nums = input.chars.map(&.to_i)

# pick up 3 cups immediately clockwise of cup
# destination => current cup label - 1 (keep subtracting if in picked up pile)
# place pick up immediate after destination cup
# new cup is clockwise current cup
def solution(nums, iterations)
  current = nums[0]
  max = nums.max
  num_map = {} of Int32 => Int32
  nums.each_with_index do |num, i|
    num_map[num] = nums[(i + 1) % nums.size]
  end

  iterations.times do
    next_pickup = current
    pickup = (0...3).map do |i|
      next_pickup = num_map[next_pickup]
      next_pickup
    end

    destination = current - 1

    if destination == 0
      destination = max
    end

    while pickup.includes?(destination)
      destination -= 1

      if destination == 0
        destination = max
      end
    end

    num_map[current] = num_map[pickup[-1]]
    num_map[pickup[-1]] = num_map[destination]
    num_map[destination] = pickup[0]
    current = num_map[current]
  end

  current = 1
  result = [] of Int32
  while result.size < num_map.size
    result << current
    current = num_map[current]
  end

  result
end

output = solution(nums, 100)
puts output[1..].join

final = input.chars.map(&.to_i)
(final.max + 1).upto(1000000) do |x|
  final << x
end

final_nums = solution(final, 10000000)
puts final_nums[1].to_i64 * final_nums[2].to_i64
