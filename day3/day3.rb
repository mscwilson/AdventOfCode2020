# Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

# ..##.......
# #...#...#..
# .#....#..#.
# ..#.#...#.#
# .#...##..#.
# ..#.##.....
# .#.#.#....#
# .#........#
# #.##...#...
# #...##....#
# .#..#...#.#

# These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times:

# ..##.........##.........##.........##.........##.........##.......  --->
# #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
# .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
# ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
# .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
# ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
# .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
# .#........#.#........#.#........#.#........#.#........#.#........#
# #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
# #...##....##...##....##...##....##...##....##...##....##...##....#
# .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

# You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

# The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

# From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

# The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

# ..##.........##.........##.........##.........##.........##.......  --->
# #..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
# .#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
# ..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
# .#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
# ..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
# .#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
# .#........#.#........X.#........#.#........#.#........#.#........#
# #.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
# #...##....##...##....##...#X....##...##....##...##....##...##....#
# .#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

# In this example, traversing the map using this slope would cause you to encounter 7 trees.

# Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?


file = File.open("test_input.txt")
input_data = file.readlines.map(&:chomp)

# part 1

# horizontal_offset = 3
# vertical_offset = 1

# tree_count = 0
# vertical_position = 0
# horizontal_position = 0

# while vertical_position < (input_data.length - 1)
#   horizontal_position += horizontal_offset
#   vertical_position += vertical_offset
#   horizontal_position -= input_data[0].length if horizontal_position >= input_data[0].length

#   tree_check = input_data[vertical_position][horizontal_position]
#   tree_count += 1 if tree_check == "#"
# end

# p "tree count is #{tree_count}"



# part 2

slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

def check_trees(input_data, horizontal_offset, vertical_offset)
  vertical_position = 0
  horizontal_position = 0
  tree_count = 0

  while vertical_position < (input_data.length - 1)
    horizontal_position += horizontal_offset
    vertical_position += vertical_offset
    horizontal_position -= input_data[0].length if horizontal_position >= input_data[0].length

    tree_check = input_data[vertical_position][horizontal_position]
    tree_count += 1 if tree_check == "#"
  end
  tree_count
end

answer_nums = []

slopes.each do |slope|
  horiz, vert = slope
  answer_nums << check_trees(input_data, horiz, vert)
end

p answer_nums.reduce(&:*)


