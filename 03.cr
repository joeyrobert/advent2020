terrain = File.read_lines("03.txt").map do |line|
  line.split("")
end

def get_trees(terrain, slope)
  x = 0
  y = 0
  trees = 0_i64
  y_size = terrain.size
  x_size = terrain[0].size

  while y < y_size
    if terrain[y][x] == "#"
      trees += 1
    end

    # slope rules
    x = (x + slope[0]) % x_size
    y += slope[1]
  end

  trees
end

# part 1
puts get_trees(terrain, [3, 1])

# part 2
slopes = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2],
]

puts slopes.map { |slope| get_trees(terrain, slope) }.product
