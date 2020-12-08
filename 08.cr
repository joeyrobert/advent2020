# part 1
lines = File.read("08.txt").split('\n')
acc = 0
pc = 0
run_before = Set(Int32).new

while true
  inst, digit = lines[pc].split(' ')
  digit = digit.to_i32

  if run_before.includes?(pc)
    puts acc
    break
  end
  run_before.add(pc)

  case inst
  when "jmp"
    pc += digit.to_i32
  when "acc"
    acc += digit.to_i32
    pc += 1
  when "nop"
    pc += 1
  end
end

# part 2
instructions = File.read_lines("08.txt").map do |line|
  x, y = line.split(' ')
  y = y.to_i32
  [x, y]
end

replacement = 0

while replacement < instructions.size
  if instructions[replacement][0] == "jmp"
    instructions[replacement][0] = "nop"
  elsif instructions[replacement][0] == "nop"
    instructions[replacement][0] = "jmp"
  end

  acc = 0
  pc = 0
  run_before = Set(Int32).new

  while pc != instructions.size
    inst, digit = instructions[pc]

    if run_before.includes?(pc)
      break
    end
    run_before.add(pc)

    case inst
    when "jmp"
      pc += digit.to_i32
    when "acc"
      acc += digit.to_i32
      pc += 1
    when "nop"
      pc += 1
    end
  end

  if pc == instructions.size
    puts acc
  end

  if instructions[replacement][0] == "jmp"
    instructions[replacement][0] = "nop"
  elsif instructions[replacement][0] == "nop"
    instructions[replacement][0] = "jmp"
  end

  replacement += 1
end
