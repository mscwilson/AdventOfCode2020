# Fortunately, a shuttle bus service is available to bring you from the sea port to the airport!
# Each bus has an ID number that also indicates how often the bus leaves for the airport.

# Bus schedules are defined based on a timestamp that measures the number of minutes since some fixed reference point in the past.
# At timestamp 0, every bus simultaneously departed from the sea port. After that, each bus travels to the airport, then various other locations, and finally returns to the sea port to repeat its journey forever.

# The time this loop takes a particular bus is also its ID number: the bus with ID 5 departs from the sea port at timestamps 0, 5, 10, 15, and so on.
# The bus with ID 11 departs at 0, 11, 22, 33, and so on. If you are there when the bus departs, you can ride that bus to the airport!

# Your notes (your puzzle input) consist of two lines. The first line is your estimate of the earliest timestamp you could depart on a bus.
# The second line lists the bus IDs that are in service according to the shuttle company; entries that show x must be out of service, so you decide to ignore them.

# To save time once you arrive, your goal is to figure out the earliest bus you can take to the airport. (There will be exactly one such bus.)

# For example, suppose you have the following notes:

# 939
# 7,13,x,x,59,x,31,19

# Here, the earliest timestamp you could depart is 939, and the bus IDs in service are 7, 13, 59, 31, and 19. Near timestamp 939, these bus IDs depart at the times marked D:

# time   bus 7   bus 13  bus 59  bus 31  bus 19
# 929      .       .       .       .       .
# 930      .       .       .       D       .
# 931      D       .       .       .       D
# 932      .       .       .       .       .
# 933      .       .       .       .       .
# 934      .       .       .       .       .
# 935      .       .       .       .       .
# 936      .       D       .       .       .
# 937      .       .       .       .       .
# 938      D       .       .       .       .
# 939      .       .       .       .       .
# 940      .       .       .       .       .
# 941      .       .       .       .       .
# 942      .       .       .       .       .
# 943      .       .       .       .       .
# 944      .       .       D       .       .
# 945      D       .       .       .       .
# 946      .       .       .       .       .
# 947      .       .       .       .       .
# 948      .       .       .       .       .
# 949      .       D       .       .       .

# The earliest bus you could take is bus ID 59. It doesn't depart until timestamp 944, so you would need to wait 944 - 939 = 5 minutes before it departs.
# Multiplying the bus ID by the number of minutes you'd need to wait gives 295.

# What is the ID of the earliest bus you can take to the airport multiplied by the number of minutes you'll need to wait for that bus?

departure_guess, bus_ids = File.read("test_input.txt").split

# Part 1
departure_guess = departure_guess.to_i
buses_in_service = bus_ids.split(",")
buses_in_service.delete("x")
buses_in_service.map!(&:to_i)

# Making a window of times to look in
latest_departure_time = departure_guess + buses_in_service.max

time_and_bus = []
finished = false
(departure_guess..latest_departure_time).each do |time|
  buses_in_service.each do |bus|
    next if finished == true
    if time % bus == 0
      p "The time is #{time} with bus #{bus}"
      time_and_bus << time
      time_and_bus << bus
      finished = true
    end
  end
end

waiting_time = time_and_bus[0] - departure_guess
p "The answer to part 1 is: #{waiting_time * time_and_bus[1]}"

# Part 2
# The shuttle company is running a contest: one gold coin for anyone that can
# find the earliest timestamp such that the first bus ID departs at that time and each subsequent listed bus ID departs at that subsequent minute.
# (The first line in your input is no longer relevant.)

# For example, suppose you have the same list of bus IDs as above:

# 7,13,x,x,59,x,31,19

# An x in the schedule means there are no constraints on what bus IDs must depart at that time.

# This means you are looking for the earliest timestamp (called t) such that:

#     Bus ID 7 departs at timestamp t.
#     Bus ID 13 departs one minute after timestamp t.
#     There are no requirements or restrictions on departures at two or three minutes after timestamp t.
#     Bus ID 59 departs four minutes after timestamp t.
#     There are no requirements or restrictions on departures at five minutes after timestamp t.
#     Bus ID 31 departs six minutes after timestamp t.
#     Bus ID 19 departs seven minutes after timestamp t.

# The only bus departures that matter are the listed bus IDs at their specific offsets from t.
# Those bus IDs can depart at other times, and other bus IDs can depart at those times.
# For example, in the list above, because bus ID 19 must depart seven minutes after the timestamp at which bus ID 7 departs,
# bus ID 7 will always also be departing with bus ID 19 at seven minutes after timestamp t.

# In this example, the earliest timestamp at which this occurs is 1068781:

# time     bus 7   bus 13  bus 59  bus 31  bus 19
# 1068773    .       .       .       .       .
# 1068774    D       .       .       .       .
# 1068775    .       .       .       .       .
# 1068776    .       .       .       .       .
# 1068777    .       .       .       .       .
# 1068778    .       .       .       .       .
# 1068779    .       .       .       .       .
# 1068780    .       .       .       .       .
# 1068781    D       .       .       .       .
# 1068782    .       D       .       .       .
# 1068783    .       .       .       .       .
# 1068784    .       .       .       .       .
# 1068785    .       .       D       .       .
# 1068786    .       .       .       .       .
# 1068787    .       .       .       D       .
# 1068788    D       .       .       .       D
# 1068789    .       .       .       .       .
# 1068790    .       .       .       .       .
# 1068791    .       .       .       .       .
# 1068792    .       .       .       .       .
# 1068793    .       .       .       .       .
# 1068794    .       .       .       .       .
# 1068795    D       D       .       .       .
# 1068796    .       .       .       .       .
# 1068797    .       .       .       .       .

# In the above example, bus ID 7 departs at timestamp 1068788 (seven minutes after t).


# I gave up on part 2
# Found this very cool solution by Github user eneagoe (https://github.com/eneagoe)
# Can't get my head around it!

# Makes a nested array of buses with their position in the bus IDs list
buses = bus_ids.split(/,/).each_with_index.map { |b, i| [b.to_i, i] if b != "x" }.compact

first, offset = buses[0][0], buses[0][0]
buses[1..-1].each do |bus|
  while (first + bus[1]) % bus[0] != 0
    first += offset
  end
  offset *= bus[0]
end

puts first


