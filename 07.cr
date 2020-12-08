parent_lookup = {} of String => Array(String)
children_lookup = {} of String => Array(Tuple(Int32, String))
File.each_line("07.txt") do |line|
  parent, children = line.split(" bags contain ")
  children = children.split(',')

  if !children_lookup[parent]?
    children_lookup[parent] = [] of Tuple(Int32, String)
  end

  children.each do |child|
    if md = child.match(/(\d+) (.*?) bags?/)
      if !parent_lookup[md[2]]?
        parent_lookup[md[2]] = [] of String
      end
      parent_lookup[md[2]] << parent
      children_lookup[parent] << {md[1].to_i32, md[2]}
    end
  end
end

# part 1
q = ["shiny gold"]
outer = Set(String).new

while q.size > 0
  value = q.pop
  outer.add(value)
  if parent_lookup[value]?
    parent_lookup[value].each do |item|
      q.push(item)
    end
  end
end

puts outer.size - 1

# part 2
q = ["shiny gold"]
count = 0

while q.size > 0
  value = q.pop
  count += 1
  if children_lookup[value]?
    children_lookup[value].each do |item|
      item[0].times do
        q.push(item[1])
      end
    end
  end
end

puts count - 1
