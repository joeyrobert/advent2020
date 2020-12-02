nums = File.read_lines("01.txt").map(&.to_i).sort

nums.each_with_index do |a, a_index|
  nums.each_with_index(a_index + 1) do |b, b_index|
    if a == b
      next
    end

    if (a + b) == 2020
      # puts "a_index: #{a_index}, b_index: #{b_index}"
      # puts "a: #{a}, b: #{b}"
      puts "1: #{a*b}"
    end
  end
end

nums.each_with_index do |a, a_index|
  nums.each_with_index(a_index + 1) do |b, b_index|
    if a == b
      next
    end
    nums.each_with_index(b_index + 1) do |c, c_index|
      if b == c
        next
      end

      if (a + b + c) == 2020
        # puts "a_index: #{a_index}, b_index: #{b_index}"
        # puts "a: #{a}, b: #{b}"
        puts "2: #{a*b*c}"
      end
    end
  end
end
