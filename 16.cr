f = File.read("16.txt")

rules, rest = f.split("your ticket:").map(&.strip)
your_ticket, other_tickets = rest.split("nearby tickets:").map(&.strip)
your_ticket = your_ticket.split(',').map(&.to_i)
other_tickets = other_tickets.split('\n').map { |ticket| ticket.split(',').map(&.to_i) }
ranges = [] of Range(Int32, Int32)
ranges_by_name = {} of String => Array(Range(Int32, Int32))

rules.split('\n').each do |rule|
  name, values = rule.split(':')
  values = values.split(" or ").map { |value| value.split('-').map(&.to_i) }

  values.each do |range|
    ranges << (range[0]..range[1])
    ranges_by_name[name] ||= Array(Range(Int32, Int32)).new
    ranges_by_name[name] << (range[0]..range[1])
  end
end

# part 1
invalid_values = [] of Int32
valid_tickets = [] of Array(Int32)

other_tickets.each do |other_ticket|
  valid_ticket = true
  other_ticket.each do |value|
    valid_value = false
    ranges.each do |range|
      if range.includes?(value)
        valid_value = true
      end
    end

    if !valid_value
      invalid_values << value
      valid_ticket = false
    end
  end

  if valid_ticket
    valid_tickets << other_ticket
  end
end

puts invalid_values.sum

# part 2
mapping = {} of String => Array(Int32)

your_ticket.size.times do |i|
  column = valid_tickets.map { |ticket| ticket[i] }

  ranges_by_name.each do |(name, ranges)|
    valid_column = true

    column.each do |value|
      valid_value = false
      ranges.each do |range|
        if range.includes?(value)
          valid_value = true
        end
      end

      if !valid_value
        valid_column = false
        break
      end
    end

    if valid_column
      mapping[name] ||= Array(Int32).new
      mapping[name] << i
      next
    end
  end
end

final_mapping = {} of String => Int32

while final_mapping.size < your_ticket.size
  must_be = mapping.find({"", [0]}) { |(name, options)| options.size == 1 }
  final_mapping[must_be[0]] = must_be[1][0]

  mapping.each do |(name, options)|
    mapping[name] = options.select { |option| option != must_be[1][0] }
  end
end

output = final_mapping.map do |(name, index)|
  name.starts_with?("departure") ? your_ticket[index].to_i64 : 1_i64
end

puts output.product
