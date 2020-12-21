lines = File.read_lines("21.txt")
ingredients_by_id = {} of Int32 => Array(String)
allergens_ingredients = {} of String => Array(Array(String))

lines.each_with_index do |line, i|
  ingredients, allergens = line.split("(contains ")
  ingredients = ingredients.strip.split(' ')
  allergens = allergens[..-2].strip.split(", ")

  ingredients_by_id[i] = [] of String
  ingredients.each do |ingredient|
    ingredients_by_id[i] << ingredient
  end

  allergens.each do |allergen|
    allergens_ingredients[allergen] ||= [] of Array(String)
    allergens_ingredients[allergen] << ingredients
  end
end

final_allergens = {} of String => String
found_integredients = Set(String).new

while allergens_ingredients.size > 0
  allergens_ingredients.each do |allergen, ingredients|
    matching_ingredients = nil
    ingredients.each do |ings|
      matching_ingredients ||= (Set.new(ings) - found_integredients)
      matching_ingredients &= (Set.new(ings) - found_integredients)
    end

    if matching_ingredients && matching_ingredients.size == 1
      ingredient = matching_ingredients.to_a[0]
      final_allergens[allergen] = ingredient
      found_integredients << ingredient
      allergens_ingredients.delete(allergen)

      break
    end
  end
end

count = 0
ingredients_by_id.each do |id, ingredients|
  ingredients.each do |ingredient|
    if !final_allergens.values.includes?(ingredient)
      count += 1
    end
  end
end

# part 1
puts count

# part 2
puts final_allergens.keys.sort.map { |allergen|
  final_allergens[allergen]
}.join(',')
