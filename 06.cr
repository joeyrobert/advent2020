f = File.read("06.txt")
decs = f.split("\n\n")

# part 1
puts decs.map { |dec|
  Set(Char).new(dec.delete('\n').chars).size
}.sum

# part 2
puts decs.map { |dec|
  dec.split('\n').map { |person|
    Set(Char).new(person.chars)
  }.reduce { |acc, set| acc & set }.size
}.sum
