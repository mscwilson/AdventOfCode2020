# The seat layout fits neatly on a grid. Each position is either floor (.), an empty seat (L), or an occupied seat (#). For example, the initial seat layout might look like this:

# L.LL.LL.LL
# LLLLLLL.LL
# L.L.L..L..
# LLLL.LL.LL
# L.LL.LL.LL
# L.LLLLL.LL
# ..L.L.....
# LLLLLLLLLL
# L.LLLLLL.L
# L.LLLLL.LL

# Now, you just need to model the people who will be arriving shortly.
# Fortunately, people are entirely predictable and always follow a simple set of rules.
# All decisions are based on the number of occupied seats adjacent to a given seat (one of the eight positions immediately up, down, left, right, or diagonal from the seat).
# The following rules are applied to every seat simultaneously:

#     If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
#     If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
#     Otherwise, the seat's state does not change.

# Floor (.) never changes; seats don't move, and nobody sits on the floor.

# After one round of these rules, every seat in the example layout becomes occupied:

# #.##.##.##
# #######.##
# #.#.#..#..
# ####.##.##
# #.##.##.##
# #.#####.##
# ..#.#.....
# ##########
# #.######.#
# #.#####.##

# After a second round, the seats with four or more occupied adjacent seats become empty again:

# #.LL.L#.##
# #LLLLLL.L#
# L.L.L..L..
# #LLL.LL.L#
# #.LL.LL.LL
# #.LLLL#.##
# ..L.L.....
# #LLLLLLLL#
# #.LLLLLL.L
# #.#LLLL.##

# This process continues for three more rounds:

# #.##.L#.##
# #L###LL.L#
# L.#.#..#..
# #L##.##.L#
# #.##.LL.LL
# #.###L#.##
# ..#.#.....
# #L######L#
# #.LL###L.L
# #.#L###.##

# #.#L.L#.##
# #LLL#LL.L#
# L.L.L..#..
# #LLL.##.L#
# #.LL.LL.LL
# #.LL#L#.##
# ..L.L.....
# #L#LLLL#L#
# #.LLLLLL.L
# #.#L#L#.##

# #.#L.L#.##
# #LLL#LL.L#
# L.#.L..#..
# #L##.##.L#
# #.#L.LL.LL
# #.#L#L#.##
# ..L.L.....
# #L#L##L#L#
# #.LLLLLL.L
# #.#L#L#.##

# At this point, something interesting happens:
# the chaos stabilizes and further applications of these rules cause no seats to change state! Once people stop moving around, you count 37 occupied seats.

# Simulate your seating area by applying the seating rules repeatedly until no seats change state. How many seats end up occupied?


# Part 2

# People don't just care about adjacent seats - they care about the first seat they can see in each of those eight directions!

# Now, instead of considering just the eight immediately adjacent seats, consider the first seat in each of those eight directions.
# For example, the empty seat below would see eight occupied seats:

# .......#.
# ...#.....
# .#.......
# .........
# ..#L....#
# ....#....
# .........
# #........
# ...#.....

# The leftmost empty seat below would only see one empty seat, but cannot see any of the occupied ones:

# .............
# .L.L.#.#.#.#.
# .............

# The empty seat below would see no occupied seats:

# .##.##.
# #.#.#.#
# ##...##
# ...L...
# ##...##
# #.#.#.#
# .##.##.

# Also, people seem to be more tolerant than you expected:
# it now takes five or more visible occupied seats for an occupied seat to become empty (rather than four or more from the previous rules).
# The other rules still apply: empty seats that see no occupied seats become occupied, seats matching no rule don't change, and floor never changes.

# Again, at this point, people stop shifting around and the seating area reaches equilibrium. Once this occurs, you count 26 occupied seats.
# Given the new visibility method and the rule change for occupied seats becoming empty, once equilibrium is reached, how many seats end up occupied?

require "ap"

file = File.open("test_input.txt", "r")
@data = file.readlines.map(&:chomp)

# Part 1
@part1 = true

# Making a copy to alter seat occupancy in so that can iterate through the original
@data_copy = @data.dup.map(&:dup)
# ap @data

def check_seat(y, x)
  case @data[y][x]
  when "."
    return
  when "L"
    @data_copy[y][x] = "#" if count_adjacent_occupied(y, x) == 0
  when "#"
    @data_copy[y][x] = "L" if (count_adjacent_occupied(y, x) >= 4 && @part1 == true) || (count_adjacent_occupied(y, x) >= 5 && @part1 == false)
  end
end

def count_adjacent_occupied(y, x)
  if @part1 == true
    return checking_adjacent_part1(y, x)
  else
    return checking_adjacent_part2(y, x)
  end
end

def count_total_occupied_seats
  total_occupied = 0
  @data.each_with_index do |line, y|
    line.chars.each_with_index do |seat, x|
      total_occupied += 1 if @data[y][x] == "#"
    end  
  end
  total_occupied
end

def seats_activity
  counter = 0
  while true
    @data.each_with_index do |line, y|
      line.chars.each_with_index do |seat, x|
        check_seat(y, x)
      end  
    end
    counter += 1
    # pp @data_copy
    break if @data == @data_copy
    @data = @data_copy.dup.map(&:dup)
  end
end

def checking_adjacent_part1(y, x)
  adjacent_occupied = 0
  to_obtain = [[x - 1, y - 1], [x, y - 1], [x + 1, y - 1], [x - 1, y], [x + 1, y], [x - 1, y + 1], [x, y + 1], [x + 1, y + 1]]
  to_obtain.each do |coords|
    test_x, test_y = coords
    next if test_x < 0 || test_x > @data[0].length - 1
    next if test_y < 0 || test_y > @data.length - 1
    adjacent_occupied += 1 if @data[test_y][test_x] == "#" 
  end
  adjacent_occupied
end

# seats_activity
# p "Total occupied seats in part1: #{count_total_occupied_seats}"

# Part 2
@part1 = false

def checking_adjacent_part2(y, x)
  adjacent_occupied = 0

  # looking north
  test_y = y - 1
  until test_y < 0
    if @data[test_y][x] == "L"
      break
    elsif @data[test_y][x] == "#"
      adjacent_occupied += 1
      break
    end
    test_y -= 1
  end

  # looking south
  test_y = y + 1
  until test_y == @data.length
    # p @data[test_y][x]
    if @data[test_y][x] == "L"
      break
    elsif @data[test_y][x] == "#"
      adjacent_occupied += 1
      break
    end
    test_y += 1
  end

  # looking east
  test_x = x + 1
  until test_x == @data[0].length
    if @data[y][test_x] == "L"
      break
    elsif @data[y][test_x] == "#"
      adjacent_occupied += 1
      break
    end
    test_x += 1
  end

  # looking west
  test_x = x - 1
  until test_x < 0
    if @data[y][test_x] == "L"
      break
    elsif @data[y][test_x] == "#"
      adjacent_occupied += 1
      break
    end
    test_x -= 1
  end

  # looking northeast
  test_x = x + 1
  test_y = y - 1
  until test_x == @data[0].length || test_y < 0
    if @data[test_y][test_x] == "L"
      break
    elsif @data[test_y][test_x] == "#"
      adjacent_occupied += 1
      break
    end
    test_x += 1
    test_y -= 1
  end

  # looking southeast
  test_x = x + 1
  test_y = y + 1
  until test_x == @data[0].length || test_y == @data.length
    if @data[test_y][test_x] == "L"
      break
    elsif @data[test_y][test_x] == "#"
      adjacent_occupied += 1
      break
    end
    test_x += 1
    test_y += 1
  end

  # looking southwest
  test_x = x - 1
  test_y = y + 1
  until test_x < 0 || test_y == @data.length
    if @data[test_y][test_x] == "L"
      break
    elsif @data[test_y][test_x] == "#"
      adjacent_occupied += 1
      break
    end
    test_x -= 1
    test_y += 1
  end

  # looking northwest
  test_x = x - 1
  test_y = y - 1
  until test_x < 0 || test_y < 0
    if @data[test_y][test_x] == "L"
      break
    elsif @data[test_y][test_x] == "#"
      adjacent_occupied += 1
      break
    end
    test_x -= 1
    test_y -= 1
  end

  adjacent_occupied
end

seats_activity
p "Total occupied seats in part2: #{count_total_occupied_seats}"
