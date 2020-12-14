f = File.read("13.txt")
depart, raw_buses = f.split('\n')

# part 1
depart = depart.to_i
buses = raw_buses.split(',').select { |bus| bus != "x" }.map(&.to_i)
next_bus = buses.map { |bus| bus - depart % bus }
index = next_bus.index(next_bus.min) || 0
puts buses[index] * next_bus.min

# part 2 (https://brilliant.org/wiki/chinese-remainder-theorem/)
buses = raw_buses.split(',').map_with_index { |bus, i| {i.to_i64, bus == "x" ? 1 : bus.to_i64} }.select { |bus| bus[1] != 1 }
n = buses.map { |bus| bus[1].to_i64 }.product
t = 0_i64

buses.each do |(index, mod)|
  y = n // mod
  t += (mod - index) * modinv(y, mod) * y
end

puts t % n

# shamelessly taken from https://rosettacode.org/wiki/Modular_inverse#Crystal
def modinv(a0, m0)
  return 1 if m0 == 1
  a, m = a0, m0
  x0, inv = 0, 1_i64
  while a > 1
    inv -= (a // m) * x0
    a, m = m, a % m
    x0, inv = inv, x0
  end
  inv += m0 if inv < 0
  inv
end
