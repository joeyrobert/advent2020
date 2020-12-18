f = File.read("17.txt")
state = Set(Tuple(Int32, Int32, Int32)).new

# part 1
f.split('\n').each_with_index do |row, x|
  row.chars.each_with_index do |ch, y|
    if ch == '#'
      state << {x, y, 0}
    end
  end
end

def get_neighbors(tpl : Tuple(Int32, Int32, Int32)) : Set(Tuple(Int32, Int32, Int32))
  neighbors = Set(Tuple(Int32, Int32, Int32)).new
  (-1..1).map do |delta_x|
    (-1..1).map do |delta_y|
      (-1..1).map do |delta_z|
        if delta_x != 0 || delta_y != 0 || delta_z != 0
          neighbors << {tpl[0] + delta_x, tpl[1] + delta_y, tpl[2] + delta_z}
        end
      end
    end
  end
  neighbors
end

def step(state : Set(Tuple(Int32, Int32, Int32)))
  new_state = Set(Tuple(Int32, Int32, Int32)).new
  active_neigbors = {} of Tuple(Int32, Int32, Int32) => Int32

  state.each do |tpl|
    neighbors = get_neighbors(tpl)
    neighbors.each do |neighbor_tpl|
      active_neigbors[neighbor_tpl] ||= 0
      active_neigbors[neighbor_tpl] += 1
    end
  end

  active_neigbors.each do |tpl, number_active|
    if state.includes?(tpl)
      if [2, 3].includes?(number_active)
        new_state << tpl
      end
    elsif number_active == 3
      new_state << tpl
    end
  end

  new_state
end

6.times do
  state = step(state)
end
puts state.size

# part 2
state = Set(Tuple(Int32, Int32, Int32, Int32)).new
f.split('\n').each_with_index do |row, x|
  row.chars.each_with_index do |ch, y|
    if ch == '#'
      state << {x, y, 0, 0}
    end
  end
end

def get_neighbors_4d(tpl : Tuple(Int32, Int32, Int32, Int32)) : Set(Tuple(Int32, Int32, Int32, Int32))
  neighbors = Set(Tuple(Int32, Int32, Int32, Int32)).new
  (-1..1).map do |delta_x|
    (-1..1).map do |delta_y|
      (-1..1).map do |delta_z|
        (-1..1).map do |delta_w|
          if delta_x != 0 || delta_y != 0 || delta_z != 0 || delta_w != 0
            neighbors << {tpl[0] + delta_x, tpl[1] + delta_y, tpl[2] + delta_z, tpl[3] + delta_w}
          end
        end
      end
    end
  end
  neighbors
end

def step(state : Set(Tuple(Int32, Int32, Int32, Int32)))
  new_state = Set(Tuple(Int32, Int32, Int32, Int32)).new
  active_neigbors = {} of Tuple(Int32, Int32, Int32, Int32) => Int32

  state.each do |tpl|
    neighbors = get_neighbors_4d(tpl)
    neighbors.each do |neighbor_tpl|
      active_neigbors[neighbor_tpl] ||= 0
      active_neigbors[neighbor_tpl] += 1
    end
  end

  active_neigbors.each do |tpl, number_active|
    if state.includes?(tpl)
      if [2, 3].includes?(number_active)
        new_state << tpl
      end
    elsif number_active == 3
      new_state << tpl
    end
  end

  new_state
end

6.times do
  state = step(state)
end
puts state.size
