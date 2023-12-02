require "set"

class Puzzle2018day1
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input()
  end

  def solve_part_1(input)
    puts "solve_part_1"
    res = 0

    input.lines.map(&:to_i).sum
  end

  def solve_part_2(input)
    res = 0
    set = Set.new
    loop do
      input.lines.map(&:to_i).each do |change|
        res += change
        return res if set.include?(res)
        set.add(res)
      end
    end
    res
  end

  def run()
    input = @original_text
    solution1 = solve_part_1(input)
    puts "Solution1: #{solution1}"
    solution2 = solve_part_2(input)
    puts "Solution2: #{solution2}"
  end
end
