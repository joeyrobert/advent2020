# Hex coordinate system:
# https://homepages.inf.ed.ac.uk/rbf/CVonline/LOCAL_COPIES/AV0405/MARTIN/Hex.pdf
directions = {
  "e":  {1, 0},
  "w":  {-1, 0},
  "se": {1, -1},
  "sw": {0, -1},
  "nw": {-1, 1},
  "ne": {0, 1},
}

lines = File.read_lines("24.txt")
black_tiles = Set(Tuple(Int32, Int32)).new

lines.each do |line|
  current = {0, 0}
  i = 0

  while i < line.size
    one = line[i..i]
    two = line[i..i + 1]

    if directions[one]?
      delta = directions[one]
      current = {current[0] + delta[0], current[1] + delta[1]}
      i += 1
    elsif directions[two]?
      delta = directions[two]
      current = {current[0] + delta[0], current[1] + delta[1]}
      i += 2
    end
  end

  if black_tiles.includes?(current)
    black_tiles.delete(current)
  else
    black_tiles << current
  end
end

puts black_tiles.size

100.times do |i|
  black_neighbors = {} of Tuple(Int32, Int32) => Int32

  black_tiles.each do |black_tile|
    directions.values.each do |delta|
      neighbor = {black_tile[0] + delta[0], black_tile[1] + delta[1]}
      black_neighbors[neighbor] ||= 0
      black_neighbors[neighbor] += 1
    end
  end

  # look at black tiles
  black_tiles.each do |tile|
    count = black_neighbors[tile]? || 0
    if count == 0 || count > 2
      black_tiles.delete(tile)
    end
  end

  # look at white tiles
  black_neighbors.each do |tile, count|
    if !black_tiles.includes?(tile) && count == 2
      black_tiles << tile
    end
  end
end

puts black_tiles.size
