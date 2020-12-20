rules, msgs = File.read("19.txt").split("\n\n").map { |x| x.strip.split('\n') }
rules_by_id = {} of String => Array(Array(String))

rules.each do |rule|
  id, sub_rules = rule.split(':')
  sub_rules = sub_rules.split('|').map { |x| x.strip.split(" ") }
  rules_by_id[id] = sub_rules
end

def resolve_rules(rules_by_id, id, fix = false)
  rule = rules_by_id[id]

  # for part 2, to prevent infinite loop
  if fix
    if id == "8"
      child = resolve_rules(rules_by_id, "42")
      return "#{child}+"
    elsif id == "11"
      child_a = resolve_rules(rules_by_id, "42")
      child_b = resolve_rules(rules_by_id, "31")

      # a bit hacky, but the only way to keep same number of 42 and 31
      regex = (1..20).map do |i|
        "(#{child_a}{#{i}}#{child_b}{#{i}})"
      end

      return "(#{regex.join('|')})"
    end
  end

  # or these
  regex = rule.map do |sub_rule|
    # value these
    inner_regex = sub_rule.map do |value|
      if value.starts_with?("\"")
        value[1].to_s
      else
        resolve_rules(rules_by_id, value, fix)
      end
    end

    inner_regex.join
  end

  "(#{regex.join('|')})"
end

# part 1
regex = Regex.new("^#{resolve_rules(rules_by_id, "0")}$")
puts msgs.select { |msg| msg =~ regex }.size

# part 2 (switching to ruby to resolve this, as Crystal chokes on big regexes)
p "^#{resolve_rules(rules_by_id, "0", true)}$"
puts msgs.select { |msg| msg =~ regex }.size
