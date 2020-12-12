lines = File.read_lines("11.txt")
rows = lines.size
cols = lines[0].size
original_squares = File.read("11.txt").chars
original_squares.delete('\n')

NEIGHBOR_OFFSETS = [
  {-1, -1},
  {-1, 0},
  {-1, 1},
  {0, -1},
  {0, 1},
  {1, -1},
  {1, 0},
  {1, 1},
]

def display(squares, rows, cols)
  rows.times do |row|
    cols.times do |col|
      print squares[row*cols + col]
    end
    puts ""
  end
  puts ""
end

def neighbors_occupied(squares, rows, cols, j)
  neighbours_occupied = 0
  NEIGHBOR_OFFSETS.each do |(x, y)|
    row = j // cols
    col = j % cols
    row += x
    col += y

    if row >= 0 && row < rows && col >= 0 && col < cols
      neighbor = row * cols + col

      if squares[neighbor] == '#'
        neighbours_occupied += 1
      end
    end
  end
  neighbours_occupied
end

def neighbors_visible(squares, rows, cols, j)
  neighbours_visible = 0
  row = j // cols
  col = j % cols
  NEIGHBOR_OFFSETS.each do |(x, y)|
    row = j // cols
    col = j % cols

    loop do
      row += x
      col += y
      neighbor = row * cols + col

      if !(row >= 0 && row < rows && col >= 0 && col < cols)
        break
      elsif squares[neighbor] == '#'
        neighbours_visible += 1
        break
      elsif squares[neighbor] == 'L'
        break
      end
    end
  end
  neighbours_visible
end

# part 1
squares = original_squares.clone
loop do
  # display(squares, rows, cols)
  number_switched = 0
  next_squares = squares.clone
  squares.each_with_index do |square, j|
    if square == '.'
      next
    end

    occupied = neighbors_occupied(squares, rows, cols, j)

    case square
    when 'L'
      if occupied == 0
        next_squares[j] = '#'
        number_switched += 1
      end
    when '#'
      if occupied >= 4
        next_squares[j] = 'L'
        number_switched += 1
      end
    end
  end

  squares = next_squares

  if number_switched == 0
    break
  end
end

puts squares.count('#')

# part 2
squares = original_squares.clone
loop do
  number_switched = 0
  next_squares = squares.clone
  squares.each_with_index do |square, j|
    if square == '.'
      next
    end

    visible = neighbors_visible(squares, rows, cols, j)

    case square
    when 'L'
      if visible == 0
        next_squares[j] = '#'
        number_switched += 1
      end
    when '#'
      if visible >= 5
        next_squares[j] = 'L'
        number_switched += 1
      end
    end
  end

  squares = next_squares

  if number_switched == 0
    break
  end
end

puts squares.count('#')
