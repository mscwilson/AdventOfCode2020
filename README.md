## Advent Of Code 2020
My solutions for days 1-13 of [Advent of Code 2020](https://adventofcode.com/2020), using Ruby.

### Description
Advent of Code is a series of Christmas-themed coding puzzles, that runs every December. Each day a new two-part puzzle is posted. Each part of the problem gives a numeric result; submitting the correct value for part 1 unlocks the more challenging second section.

I successfully completed both parts of the challenge for days 1-12, and part 1 of day 13. Decided to call it a day there and enjoy my Christmas holidays!

These Advent of Code problems were my first time experiencing challenges that needed recursion to solve, or where efficiency had to be considered. For several of the puzzles (including day 13) I initially wrote code that gave the right answer for the minimal test data but was so inefficient that it ran forever on the real input. I'm particularly proud of my day 7 solution (counting bags inside bags).

I also learned the importance of copying/deepcopying objects using dup, such as in day 11's "simultaneous" seat filling.

I'm looking forward to Advent of Code 2021 -  hopefully I will be able to complete more of the puzzles! My code will definitely be cleaner and more readable then, at least.

### Running the code
Clone this repo and navigate into the cloned folder.  
Each day's puzzle has its own folder, containing three files: the Ruby code; the test input given in the instructions, with known answer; and the full data to analyse.
* For each day, `cd` into the folder, eg `cd day9`
* Run the code: `ruby day9.rb`
* The answer to the puzzle will be printed into the terminal

There are no tests because I didn't know about testing at the time.
