lines = File.read_lines("12.txt")

# part 1
x = 0
y = 0
deg = 90
lines.each do |line|
  num = line[1..].to_i
  case line[0]
  when 'N'
    y -= num
  when 'S'
    y += num
  when 'E'
    x += num
  when 'W'
    x -= num
  when 'L'
    deg -= num
  when 'R'
    deg += num
  when 'F'
    # SOH CAH TOA
    radians = deg * Math::PI / 180
    delta_y = -1 * (num * Math.cos(radians))
    delta_x = (num * Math.sin(radians))
    x += delta_x
    y += delta_y
  end
end

puts x.abs + y.abs

# part 2
waypoint_x = 10
waypoint_y = -1
x = 0
y = 0
lines.each do |line|
  num = line[1..].to_i
  case line[0]
  when 'N'
    waypoint_y -= num
  when 'S'
    waypoint_y += num
  when 'E'
    waypoint_x += num
  when 'W'
    waypoint_x -= num
  when 'L'
    radians = -num * Math::PI / 180
    new_waypoint_x = waypoint_x * Math.cos(radians) - waypoint_y * Math.sin(radians)
    new_waypoint_y = waypoint_x * Math.sin(radians) + waypoint_y * Math.cos(radians)
    waypoint_x = new_waypoint_x
    waypoint_y = new_waypoint_y
  when 'R'
    radians = num * Math::PI / 180
    new_waypoint_x = waypoint_x * Math.cos(radians) - waypoint_y * Math.sin(radians)
    new_waypoint_y = waypoint_x * Math.sin(radians) + waypoint_y * Math.cos(radians)
    waypoint_x = new_waypoint_x
    waypoint_y = new_waypoint_y
  when 'F'
    radians = deg * Math::PI / 180
    delta_y = -1 * (num * Math.cos(radians))
    delta_x = (num * Math.sin(radians))
    x += waypoint_x * num
    y += waypoint_y * num
  end
end

puts (x.abs + y.abs).round.to_i
