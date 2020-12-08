# The boot code is represented as a text file with one instruction per line of text.
# Each instruction consists of an operation (acc, jmp, or nop) and an argument (a signed number like +4 or -20).

#     acc increases or decreases a single global value called the accumulator by the value given in the argument.
#     For example, acc +7 would increase the accumulator by 7.
#     The accumulator starts at 0. After an acc instruction, the instruction immediately below it is executed next.
#     jmp jumps to a new instruction relative to itself.
#     The next instruction to execute is found using the argument as an offset from the jmp instruction;
#     for example, jmp +2 would skip the next instruction, jmp +1 would continue to the instruction immediately below it,
#       and jmp -20 would cause the instruction 20 lines above to be executed next.
#     nop stands for No OPeration - it does nothing. The instruction immediately below it is executed next.

# For example, consider the following program:

# nop +0
# acc +1
# jmp +4
# acc +3
# jmp -3
# acc -99
# acc +1
# jmp -4
# acc +6

# These instructions are visited in this order:

# nop +0  | 1
# acc +1  | 2, 8(!)
# jmp +4  | 3
# acc +3  | 6
# jmp -3  | 7
# acc -99 |
# acc +1  | 4
# jmp -4  | 5
# acc +6  |

# First, the nop +0 does nothing. Then, the accumulator is increased from 0 to 1 (acc +1) and
# jmp +4 sets the next instruction to the other acc +1 near the bottom.
# After it increases the accumulator from 1 to 2, jmp -4 executes, setting the next instruction to the only acc +3.
# It sets the accumulator to 5, and jmp -3 causes the program to continue back at the first acc +1.

# This is an infinite loop: with this sequence of jumps, the program will run forever.
# The moment the program tries to run any instruction a second time, you know it will never terminate.

# Immediately before the program would run an instruction a second time, the value in the accumulator is 5.
# Run your copy of the boot code. Immediately before any instruction is executed a second time, what value is in the accumulator?

file = File.open("input.txt")
input_data = file.readlines.map(&:chomp)

instructions_list = []

# Making the data into an array of instructions. Each instruction is eg [2, "jmp", 4]
input_data.each_with_index do |line, i|
  instructions_list.push([i, line.split(" ")[0], line.split(" ")[1].to_i])
end


# Part 1
accumulator = 0
seen_this = []

def operation(n, instructions, counter, checklist)
  return "Looping round. Accumulator is: #{counter}" if checklist.include?(instructions[n][0])
  checklist << instructions[n][0]

  if instructions[n][1] == "acc"
    counter += instructions[n][2]
    operation((n + 1), instructions, counter, checklist)
  elsif instructions[n][1] == "jmp"
    operation((instructions[n][0] + instructions[n][2]), instructions, counter, checklist)
  elsif instructions[n][1] == "nop"
    operation((n + 1), instructions, counter, checklist)
  end
end

p operation(0, instructions_list, accumulator, seen_this)



# Part 2


# After some careful analysis, you believe that exactly one instruction is corrupted.

# Somewhere in the program, either a jmp is supposed to be a nop, or a nop is supposed to be a jmp.
# (No acc instructions were harmed in the corruption of this boot code.)

# The program is supposed to terminate by attempting to execute an instruction immediately after the last instruction in the file.
# By changing exactly one jmp or nop, you can repair the boot code and make it terminate correctly.

# For example, consider the same program from above:

# nop +0
# acc +1
# jmp +4
# acc +3
# jmp -3
# acc -99
# acc +1
# jmp -4
# acc +6

# If you change the first instruction from nop +0 to jmp +0, it would create a single-instruction infinite loop,
# never leaving that instruction. If you change almost any of the jmp instructions,
# the program will still eventually find another jmp instruction and loop forever.

# However, if you change the second-to-last instruction (from jmp -4 to nop -4),
# the program terminates! The instructions are visited in this order:

# nop +0  | 1
# acc +1  | 2
# jmp +4  | 3
# acc +3  |
# jmp -3  |
# acc -99 |
# acc +1  | 4
# nop -4  | 5
# acc +6  | 6

# After the last instruction (acc +6), the program terminates by attempting to run the instruction below the last instruction in the file.
# With this change, after the program terminates, the accumulator contains the value 8 (acc +1, acc +1, acc +6).

# Fix the program so that it terminates normally by changing exactly one jmp (to nop) or nop (to jmp).
# What is the value of the accumulator after the program terminates?


# Making an array of the different permutations of instructions_list
modified_instructions = []
done_this_one = []

nop_jmp_count = 0
instructions_list.each { |line| nop_jmp_count += 1 if line[1] == "nop" or line[1] == "jmp"}

while modified_instructions.length < nop_jmp_count
  modified_instructions << []
  
  counter = 0
  instructions_list.each_with_index do |line, i|
    
    if done_this_one.include?(i) && counter  > 0
      modified_instructions[-1] << line

    elsif line[1] == "nop" && (!done_this_one.include?(i) && counter == 0)
      counter += 1
      done_this_one << i
      modified_instructions[-1].push([line[0], "jmp", line[2]])

    elsif line[1] == "jmp" && (!done_this_one.include?(i) && counter  == 0)
      counter += 1
      done_this_one << i
      modified_instructions[-1].push([line[0], "nop", line[2]])

    else
      modified_instructions[-1] << line
    end
  end
end

# Updated version of method from part 1
def operation2(n, instructions, counter, checklist)

  if n == (instructions.length - 1)
    counter += instructions[n][2] if instructions[n][1] == "acc"
    return "Got to the end! Accumulator is: #{counter}"
  end
   
  return "Looping round. Accumulator is: #{counter}" if checklist.include?(instructions[n][0])
  
  checklist << instructions[n][0]

  if instructions[n][1] == "acc"
    counter += instructions[n][2]
    operation2((n + 1), instructions, counter, checklist)

  elsif instructions[n][1] == "jmp"
    operation2((instructions[n][0] + instructions[n][2]), instructions, counter, checklist)

  elsif instructions[n][1] == "nop"
    operation2((n + 1), instructions, counter, checklist)
  end

end

# Looping over all possible permutations of the instructions
modified_instructions.each do |list|
  accumulator = 0
  seen_this = []
  
  result = operation2(0, list, accumulator, seen_this)
  if result.include?("end")
    p result
    break
  end
end
