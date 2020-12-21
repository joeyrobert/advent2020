tiles = File.read("20.txt").split("\n\n")

# part 1
# can only use each tile once
# each inner tile has ALL 4 edges matched
# outer tiles have 3 edges matched
# corner tiles have 2 edges matched
edges_to_ids = {} of Int64 => Array(Int64)
id_to_rows = {} of Int64 => Array(String)
id_to_edges = {} of Int64 => Array(Int64)
neighbors = {} of Int64 => Array(Int64)

tiles.each do |tile|
  id = /Tile (\d+):/.match(tile)
  id = id && id[1]? ? id[1].to_i64 : 0_i64
  rows = tile.strip.split('\n')
  id_to_rows[id] = rows[1..]
  sides = get_sides(rows[1..])
  # reverse each of these to get all flips
  sides_reverse = sides.map { |x| x.reverse.to_i64(2) }
  sides = sides.map { |x| x.to_i64(2) }

  sides.each do |corner|
    edges_to_ids[corner] ||= [] of Int64
    edges_to_ids[corner] << id
  end

  sides_reverse.each do |corner|
    edges_to_ids[corner] ||= [] of Int64
    edges_to_ids[corner] << id
  end
end

counts = {} of Int64 => Int64
edges_to_ids.select { |edge, ids| ids.size == 1 }.values.each do |x|
  counts[x[0]] ||= 0
  counts[x[0]] += 1
end

corner_ids = counts.select { |id, count| count == 4 }.keys
puts corner_ids.product

# find edge alignments
edges_to_ids.each do |edge, ids|
  ids.each do |id|
    id_to_edges[id] ||= [] of Int64
    id_to_edges[id] << edge
  end
end

# find neighbors of each one
id_to_edges.each do |id, edges|
  neighbors[id] = [] of Int64

  edges.each do |edge|
    matching_ids = edges_to_ids[edge].select { |edge_id| id != edge_id }
    neighbors[id].concat(matching_ids)
  end

  neighbors[id].uniq!
end

def get_sides(rows)
  binary = rows.map { |x| x.chars.map { |y| y == '#' ? '1' : '0' }.join }
  sides = [0, -1].map { |i| binary.map { |x| x.chars[i] }.join }

  [
    binary[0],  # top
    sides[0],   # left
    binary[-1], # bottom
    sides[1],   # right
  ]
end

def get_sides_int(rows)
  get_sides(rows).map { |x| x.to_i64(2) }
end

def flip_x(rows)
  rows.map do |row|
    row.reverse
  end
end

def flip_y(rows)
  rows.reverse
end

def rotate(rows)
  output = Array(Array(Char)).new(rows.size) { [' ']*rows.size }
  rows.size.times do |x|
    rows.size.times do |y|
      output[y][rows.size - x - 1] = rows[x][y]
    end
  end
  output.map { |row| row.join }
end

def get_candidates(rows)
  [
    rows,
    rotate(rows),
    rotate(rotate(rows)),
    rotate(rotate(rotate(rows))),
    flip_y(rows),
    flip_x(rows),
    flip_y(rotate(rows)),
    flip_x(rotate(rows)),
  ]
end

# part 2
# for each edge, find the other edge that matches up with it
# what does that edge say about the orientation of the square?
# find bottom right corner => needs edges on top and left to have neighbors
corner_id = neighbors.select { |id, neighbors| neighbors.size == 2 }.keys[0]
corner_rows = id_to_rows[corner_id]

get_candidates(id_to_rows[corner_id]).each do |candidate_rows|
  sides = get_sides_int(candidate_rows)

  if edges_to_ids[sides[0]].select { |edge_id| corner_id != edge_id }.size > 0 && edges_to_ids[sides[1]].select { |edge_id| corner_id != edge_id }.size > 0
    corner_rows = candidate_rows
    break
  end
end

output = {} of Tuple(Int32, Int32) => Array(String)
q = [{0, 0, corner_id, corner_rows}]
seen_before = Set(Int64).new
offsets = [
  {0, -1},
  {-1, 0},
  {0, 1},
  {1, 0},
]

while q.size > 0
  x, y, id, rows = q.pop

  if seen_before.includes?(id)
    next
  end

  seen_before << id
  output[{x, y}] = rows

  # look for neighbor rows
  # only look to the bottom, right
  sides = get_sides_int(rows)
  # use this next to only look top, left
  sides[0..1].each_with_index do |edge, i|
    offset = offsets[i]
    matching_ids = edges_to_ids[edge].select { |edge_id| id != edge_id && !seen_before.includes?(edge_id) }

    # for EDGE find matching ID that equals that edge
    # check top and left conditions
    matching_ids.each do |matching_id|
      matching_rows = id_to_rows[matching_id]

      get_candidates(matching_rows).each do |candidate_rows|
        candidate_sides = get_sides_int(candidate_rows)

        # compare current TOP with candidate BOTTOM
        # compare current LEFT with candidate RIGHT
        if edge == candidate_sides[i + 2]
          q << {x + offset[0], y + offset[1], matching_id, candidate_rows}
          break
        end
      end
    end
  end
end

min_x = output.keys.map { |item| item[0] }.min
min_y = output.keys.map { |item| item[1] }.min
max_x = output.keys.map { |item| item[0] }.max
max_y = output.keys.map { |item| item[1] }.max
row_size = output.values[0].size

map = ""
(min_y..max_y).each do |y|
  (1..row_size - 2).each do |row|
    (min_x..max_x).each do |x|
      if output[{x, y}]?
        map += output[{x, y}][row][1..-2]
      end
    end
    map += "\n"
  end
end

# puts map
map_width = map.split('\n')[0].size

# sea monster
monster = "                  #
#    ##    ##    ###
 #  #  #  #  #  #   "

monster_ids = [] of Int32

monster.split('\n').each_with_index do |monster_row, i|
  monster_row.chars.each_with_index do |monster_col, j|
    if monster_col == '#'
      monster_ids << i * map_width + j
    end
  end
end

split_map = map.strip.split('\n')
output_map = [] of Array(Char)
part_of_monster = [] of Int32

get_candidates(split_map).each do |candidate_map|
  number_found = 0
  parsed_map = candidate_map.flat_map(&.chars)
  part_of_monster = [] of Int32

  (0...(parsed_map.size - monster_ids.max)).each do |i|
    found_one = true
    monster_ids.each do |monster_id|
      if parsed_map[i + monster_id] != '#'
        found_one = false
        break
      end
    end

    if found_one
      number_found += 1

      monster_ids.each do |monster_id|
        part_of_monster << i + monster_id
      end
    end
  end

  if number_found > 0
    output_map = parsed_map
    break
  end
end

count = 0
output_map.each_with_index do |ch, i|
  if ch == '#' && !part_of_monster.includes?(i)
    count += 1
  end
end
puts count
