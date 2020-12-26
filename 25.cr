input = [5290733_i64, 15231938_i64]

def transform(subject, loop_size)
  value = 1_i64
  loop_size.times do
    value = (value * subject) % 20201227
  end
  value
end

def transform_target(subject, target)
  i = 0_i64
  value = 1_i64
  while value != target
    value = (value * subject) % 20201227
    i += 1
  end
  i
end

loop_sizes = input.map { |target| transform_target(7, target) }

encryption_key = transform(input[0], loop_sizes[1])
puts encryption_key
