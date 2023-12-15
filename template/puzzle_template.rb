# frozen_string_literal: true

# Solve AoC puzzle for the day {day} {year}
class Puzzle{year}day{day}
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
    
  end

  def parse_input(original)
    parsed = original.chomp
    original.lines {|l| l.split(" ")}
    parsed
  end

  def part1(input)
    res = 0

    res
  end

  def part2(input)
    res = 0

    res
  end

  def run()
    puts "🎄 Puzzle {year} {day}"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end
end
