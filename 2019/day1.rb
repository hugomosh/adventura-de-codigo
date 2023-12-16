class Puzzle2019day1
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input; end

  def solve_part_1(_input)
    0
  end

  def solve_part_2(_input)
    0
  end

  def run
    input = @original_text
    solution1 = solve_part_1(input)
    puts "Solution1: #{solution1}"
    solution2 = solve_part_2(input)
    puts "Solution2: #{solution2}"
  end
end
