file = File.open("input.txt")
input_data = file.readlines.map(&:chomp)
passports_list = []
counter = 0
input_data.each do |line|
  if line == ""
    counter += 1
  elsif passports_list[counter] == nil
    passports_list << line
  else
    passports_list[counter] << " " + line
  end
end


# # Part 1

# required_fields = %w[byr iyr eyr hgt hcl ecl pid]

# invalid_counter = 0
# passports_list.each do |passport|
#   required_fields.each do |field|
#     # p passport.include?(field)
#     invalid_counter += 1 if passport.include?(field) == false

#     break if passport.include?(field) == false

#   end

# end

# # p invalid_counter
# p "Number of valid passports is: #{passports_list.length -  invalid_counter}"



# part 2

# You can continue to ignore the cid field, but each other field has strict rules about what values are valid for automatic validation:

#     byr (Birth Year) - four digits; at least 1920 and at most 2002.
#     iyr (Issue Year) - four digits; at least 2010 and at most 2020.
#     eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
#     hgt (Height) - a number followed by either cm or in:
#         If cm, the number must be at least 150 and at most 193.
#         If in, the number must be at least 59 and at most 76.
#     hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
#     ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
#     pid (Passport ID) - a nine-digit number, including leading zeroes.
#     cid (Country ID) - ignored, missing or not.

results = []

requirements = {
  :byr => (1920..2002),
  :iyr => (2010..2020),
  :eyr => (2020..2030),
  :hgt => /^([0-9]{2,3})(cm|in)/,
  :hcl => /^\#{1}[a-f0-9]{6}\b/,
  :ecl => /^(amb|blu|brn|gry|grn|hzl|oth)$/,
  :pid => /^\d{9}\b/
  # :cid => "irrelevant"
}

# Improved version of first part - checking all the fields are present
required_fields = %w[byr iyr eyr hgt hcl ecl pid]
passports_list.each_with_index do |passport, i|
  required_fields.each do |field|
    results.push("Invalid passport #{i}") if passport.include?(field) == false
    break if passport.include?(field) == false
  end
end

# making a nested array
split_passports_list = passports_list.map { |str| str.split(" ") }.map { |arr| arr.map { |field| field.split(":") } }

# Checking all the fields have the correct type of info
split_passports_list.each_with_index do |passport, i|
  passport.each do |info|

    if info[0] == "hgt" # Height checking within range
      height_check = info[1].match(requirements[:hgt])
      if height_check == nil
        results.push("Invalid passport #{i}")        
      else
        if height_check[2] == "cm"
          results.push("Invalid passport #{i}") if !(150..193).include?(height_check[1].to_i)
        elsif info[1].match(requirements[:hgt])[2] == "in"
          results.push("Invalid passport #{i}") if !(59..76).include?(height_check[1].to_i)
        end
      end

    elsif info[0] == "byr" || info[0] == "iyr" || info[0] == "eyr" # Checking within range
      results.push("Invalid passport #{i}") if !requirements[info[0].to_sym].include?(info[1].to_i)

    elsif info[0] == "pid" || info[0] == "hcl" || info[0] == "ecl" # Checking correct format
      results.push("Invalid passport #{i}") if !info[1].match?(requirements[info[0].to_sym])
    end
  end
end

p "Number of valid passports is: #{passports_list.length - results.uniq.length}"