# For example, consider the following rules:

# light red bags contain 1 bright white bag, 2 muted yellow bags.
# dark orange bags contain 3 bright white bags, 4 muted yellow bags.
# bright white bags contain 1 shiny gold bag.
# muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
# shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
# dark olive bags contain 3 faded blue bags, 4 dotted black bags.
# vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
# faded blue bags contain no other bags.
# dotted black bags contain no other bags.

# These rules specify the required contents for 9 bag types. In this example, every faded blue bag is empty, every vibrant plum bag contains 11 bags (5 faded blue and 6 dotted black), and so on.

# You have a shiny gold bag. If you wanted to carry it in at least one other bag, how many different bag colors would be valid for the outermost bag? (In other words: how many colors can, eventually, contain at least one shiny gold bag?)

# In the above rules, the following options would be available to you:

#     A bright white bag, which can hold your shiny gold bag directly.
#     A muted yellow bag, which can hold your shiny gold bag directly, plus some other bags.
#     A dark orange bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.
#     A light red bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.

# So, in this example, the number of bag colors that can eventually contain at least one shiny gold bag is 4.

# How many bag colors can eventually contain at least one shiny gold bag?


file = File.open("input.txt")
input_data = file.readlines.map(&:chomp)

bags_dict = {}

# Separating the main holder bags (keys) from their inside bags into a hash
input_data.each do |line|
  separated = line.split(" bags contain ")
  bags_dict[separated[0].gsub(/\s+/,"_").to_sym] = separated[1]
end

# Making the values into a flat list of bags. Values are now [:bright_white, :muted_yellow, :muted_yellow] etc
bags_dict.update(bags_dict) do |k, v|
  if v == "no other bags"
    v = []
  else
    v = v.scan(/([0-9]+ [a-z]+[\s]{1}[a-z]+) bags*,*/).flatten
    new_values = []
    v.map do |e|
      number_and_colour = e.match(/([0-9]+ )([a-z]+ [a-z]+)/)
      this_many_bags = number_and_colour[1].strip.to_i
      bag_colour = number_and_colour[2].gsub(/\s+/,"_").to_sym
      new_values << [bag_colour] * this_many_bags
    end
    new_values.flatten
  end
end

# Part 1
# Need a number to iterate over. The max number of bags in a bag?
longest_value = 0
bags_dict.each { |k, v| longest_value = v.length if v.length > longest_value}
# p "Longest v is #{longest_value} long"

# Finding which bags eventually have gold inside
gold_keys = [:shiny_gold]
longest_value.times do bags_dict.each do |k, v|
    gold_keys.each { |colour| gold_keys << k if v.include?(colour) && !gold_keys.include?(k) }
  end
end

p "Gold bag count is: #{gold_keys.length - 1}" # minus 1 because seeded the gold_keys list with :shiny_gold

puts

# Part 2
# Consider again your shiny gold bag and the rules from the above example:

#     faded blue bags contain 0 other bags.
#     dotted black bags contain 0 other bags.
#     vibrant plum bags contain 11 other bags: 5 faded blue bags and 6 dotted black bags.
#     dark olive bags contain 7 other bags: 3 faded blue bags and 4 dotted black bags.

# So, a single shiny gold bag must contain 1 dark olive bag (and the 7 bags within it)
# plus 2 vibrant plum bags (and the 11 bags within each of those): 1 + 1*7 + 2 + 2*11 = 32 bags!

# How many individual bags are required inside your single shiny gold bag?

holding_colours = [:shiny_gold] # This will store the bags that were inside others. Contains :shiny_gold to start off the loop below
bags_count = 0

# Counting interior bags
holding_colours.each do |key_colour|
    bags_count += bags_dict[key_colour].length # number of bags is length of value list for each key (each holding bag)
    bags_dict[key_colour].each { |bag_value| holding_colours << bag_value } # Adding each internal bag to the list, to be looped over
end

p "This many bags inside: #{bags_count}"
