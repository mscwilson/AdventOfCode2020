# The navigation instructions (your puzzle input) consists of a sequence of single-character actions paired with integer input values.
# After staring at them for a few minutes, you work out what they probably mean:

#     Action N means to move north by the given value.
#     Action S means to move south by the given value.
#     Action E means to move east by the given value.
#     Action W means to move west by the given value.
#     Action L means to turn left the given number of degrees.
#     Action R means to turn right the given number of degrees.
#     Action F means to move forward by the given value in the direction the ship is currently facing.

# The ship starts by facing east. Only the L and R actions change the direction the ship is facing.
# (That is, if the ship is facing east and the next instruction is N10, the ship would move north 10 units, but would still move east if the following action were F.)

# For example:

# F10
# N3
# F7
# R90
# F11

# These instructions would be handled as follows:

#     F10 would move the ship 10 units east (because the ship starts by facing east) to east 10, north 0.
#     N3 would move the ship 3 units north to east 10, north 3.
#     F7 would move the ship another 7 units east (because the ship is still facing east) to east 17, north 3.
#     R90 would cause the ship to turn right by 90 degrees and face south; it remains at east 17, north 3.
#     F11 would move the ship 11 units south to east 17, south 8.

# At the end of these instructions, the ship's Manhattan distance
# (sum of the absolute values of its east/west position and its north/south position) from its starting position is 17 + 8 = 25.

# Figure out where the navigation instructions lead. What is the Manhattan distance between that location and the ship's starting position?


input_data = File.read("test_input.txt").split
# p input_data

# Part 1
# North/south, east/west
compass_position = [0, 0]
# Facing north is 0º
facing_direction = [90] # This is an array instead of an int so that it's mutable, no annoying scope problem

def action_n(compass_position, num)
  compass_position[0] += num
end

def action_s(compass_position, num)
  compass_position[0] -= num
end

def action_e(compass_position, num)
  compass_position[1] += num
end

def action_w(compass_position, num)
  compass_position[1] -= num
end

def action_l(facing_direction, num)
  facing_direction[0] -= num
  facing_direction[0] %= 360
end

def action_r(facing_direction, num)
  facing_direction[0] += num
  facing_direction[0] %= 360
end

def action_f(compass_position, facing_direction, num)
  case facing_direction[0]
  when 0
    action_n(compass_position, num)
  when 90
    action_e(compass_position, num)
  when 180
    action_s(compass_position, num)
  when 270
    action_w(compass_position, num)
  end
end

def take_action(compass_position, facing_direction, instruction)
  action, num = instruction[0], instruction[1..-1].to_i
  case action
  when "N"
    action_n(compass_position, num)
  when "S"
    action_s(compass_position, num)
  when "E"
    action_e(compass_position, num)
  when "W"
    action_w(compass_position, num)
  when "L"
    action_l(facing_direction, num)
  when "R"
    action_r(facing_direction, num)
  when "F"
    action_f(compass_position, facing_direction, num)
  end
end

input_data.each { |line| take_action(compass_position, facing_direction, line) }
p "The Manhattan distance is: #{compass_position[0].abs + compass_position[1].abs}"


# Part 2

# Before you can give the destination to the captain, you realize that the actual action meanings were printed on the back of the instructions the whole time.

# Almost all of the actions indicate how to move a waypoint which is relative to the ship's position:

#     Action N means to move the waypoint north by the given value.
#     Action S means to move the waypoint south by the given value.
#     Action E means to move the waypoint east by the given value.
#     Action W means to move the waypoint west by the given value.
#     Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
#     Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
#     Action F means to move forward to the waypoint a number of times equal to the given value.

# The waypoint starts 10 units east and 1 unit north relative to the ship.
# The waypoint is relative to the ship; that is, if the ship moves, the waypoint moves with it.

# For example, using the same instructions as above:

#     F10 moves the ship to the waypoint 10 times (a total of 100 units east and 10 units north), leaving the ship at east 100, north 10. The waypoint stays 10 units east and 1 unit north of the ship.
#     N3 moves the waypoint 3 units north to 10 units east and 4 units north of the ship. The ship remains at east 100, north 10.
#     F7 moves the ship to the waypoint 7 times (a total of 70 units east and 28 units north), leaving the ship at east 170, north 38. The waypoint stays 10 units east and 4 units north of the ship.
#     R90 rotates the waypoint around the ship clockwise 90 degrees, moving it to 4 units east and 10 units south of the ship. The ship remains at east 170, north 38.
#     F11 moves the ship to the waypoint 11 times (a total of 44 units east and 110 units south), leaving the ship at east 214, south 72. The waypoint stays 4 units east and 10 units south of the ship.

# After these operations, the ship's Manhattan distance from its starting position is 214 + 72 = 286.

# North/south, east/west
ship_compass_position = [0, 0]
waypoint_relative_position = [1, 10]

def action_2(waypoint_relative_position, action, num) # Action will be "L" or "R"
  y, x = waypoint_relative_position
  if (num == 90 && action == "R") || (num == 270 && action == "L")
    waypoint_relative_position[0] = -x
    waypoint_relative_position[1] = y
  elsif (num == 270 && action == "R") || (num == 90 && action == "L")
    waypoint_relative_position[0] = x
    waypoint_relative_position[1] = -y
  elsif num == 180
    waypoint_relative_position[0] = -y
    waypoint_relative_position[1] = -x
  end
end

def action_f2(ship_compass_position, waypoint_relative_position, num)
  ship_compass_position[0] += waypoint_relative_position[0] * num
  ship_compass_position[1] += waypoint_relative_position[1] * num
end

def take_action2(ship_compass_position, waypoint_relative_position, instruction)
  action, num = instruction[0], instruction[1..-1].to_i
  case action
  when "N"
    action_n(waypoint_relative_position, num)
  when "S"
    action_s(waypoint_relative_position, num)
  when "E"
    action_e(waypoint_relative_position, num)
  when "W"
    action_w(waypoint_relative_position, num)
  when "L", "R"
    action_2(waypoint_relative_position, action, num)
  when "F"
    action_f2(ship_compass_position, waypoint_relative_position, num)
  end
end

input_data.each { |line| take_action2(ship_compass_position, waypoint_relative_position, line) }
p "The Manhattan distance in part 2 is: #{ship_compass_position[0].abs + ship_compass_position[1].abs}"
