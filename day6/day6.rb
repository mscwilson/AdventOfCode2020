# Each group's answers are separated by a blank line, and within each group, each person's answers are on a single line. For example:

# abc

# a
# b
# c

# ab
# ac

# a
# a
# a
# a

# b

# This list represents answers from five groups:

#     The first group contains one person who answered "yes" to 3 questions: a, b, and c.
#     The second group contains three people; combined, they answered "yes" to 3 questions: a, b, and c.
#     The third group contains two people; combined, they answered "yes" to 3 questions: a, b, and c.
#     The fourth group contains four people; combined, they answered "yes" to only 1 question, a.
#     The last group contains one person who answered "yes" to only 1 question, b.

# In this example, the sum of these counts is 3 + 3 + 3 + 1 + 1 = 11.

# For each group, count the number of questions to which anyone answered "yes". What is the sum of those counts?

# Part 1

file = File.open("input.txt")
input_data = file.readlines.map(&:chomp)

groups_list = [[]]
input_data.each do |line|
  if line == ""
    groups_list << []
  else
    groups_list[-1] << line
  end
end

# counting answers Part 1
question_count = 0
groups_list.each do |group|
  question_count += group.reduce(&:+).chars.uniq.length
end

p "Anyone answered yes: #{question_count}"

# Part 2

# You don't need to identify the questions to which anyone answered "yes";
# you need to identify the questions to which everyone answered "yes"!

# This list represents answers from five groups:

#     In the first group, everyone (all 1 person) answered "yes" to 3 questions: a, b, and c.
#     In the second group, there is no question to which everyone answered "yes".
#     In the third group, everyone answered yes to only 1 question, a. Since some people did not answer "yes" to b or c, they don't count.
#     In the fourth group, everyone answered yes to only 1 question, a.
#     In the fifth group, everyone (all 1 person) answered "yes" to 1 question, b.

# In this example, the sum of these counts is 3 + 0 + 1 + 1 + 1 = 6.

# For each group, count the number of questions to which everyone answered "yes". What is the sum of those counts?

# Combine the answers from all the people within a group into one string each
groups_list_reduced = groups_list.map { |group| group.reduce(&:+) }

consensus_counter = 0
groups_list_reduced.each_with_index do |group, i|
  consensus_list = []
  group.chars.each do |char|
    consensus_list.push("Consensus on question #{char}") if group.count(char) == groups_list[i].length
  end
  consensus_counter += consensus_list.uniq.length
end

p "Answers with consensus: #{consensus_counter}"