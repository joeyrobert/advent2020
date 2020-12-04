f = File.read("04.txt")
passports = f.split("\n\n")

fields = Set.new([
  "byr",
  "iyr",
  "eyr",
  "hgt",
  "hcl",
  "ecl",
  "pid",
  # "cid",
])

# part 1
count = 0

passports.each do |passport|
  keys = Set(String).new
  passport.split('\n').each do |line|
    if line == ""
      next
    end
    line.split(' ').each do |item|
      key, value = item.split(':')
      keys.add(key)
    end
  end

  if fields.subset?(keys)
    count += 1
  end
end

puts count

# part 2
count = 0

validations = {
  "byr" => ->(value : String) { value =~ /^\d{4}$/ && value.to_i >= 1920 && value.to_i <= 2002 },
  "iyr" => ->(value : String) { value =~ /^\d{4}$/ && value.to_i >= 2010 && value.to_i <= 2020 },
  "eyr" => ->(value : String) { value =~ /^\d{4}$/ && value.to_i >= 2020 && value.to_i <= 2030 },
  "hgt" => ->(value : String) { value =~ /^\d{2,3}(cm|in)$/ && (value[-2..-1] == "cm" ? (value[...-2].to_i >= 150 && value[...-2].to_i <= 193) : (value[...-2].to_i >= 59 && value[...-2].to_i <= 76)) },
  "hcl" => ->(value : String) { value =~ /^\#[0-9a-f]{6}$/ },
  "ecl" => ->(value : String) { %w(amb blu brn gry grn hzl oth).includes?(value) },
  "pid" => ->(value : String) { value =~ /^\d{9}$/ },
  "cid" => ->(value : String) { true },
}

passports.each do |passport|
  keys = Set(String).new
  passport.split('\n').each do |line|
    if line == ""
      next
    end
    line.split(' ').each do |item|
      key, value = item.split(':')
      if validations[key].call(value)
        keys.add(key)
      end
    end
  end

  if fields.subset?(keys)
    count += 1
  end
end

puts count
