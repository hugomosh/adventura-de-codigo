class Puzzle{year}day{day}
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original
    parsed
  end

  def solve_part_1(input)
    res = 0

    res
  end

  def solve_part_2(input)
    res = 0

    res
  end

  def run()
    input = parse_input(@original_text)
    solution1 = solve_part_1(input)
    puts "Solution1: #{solution1}"
    solution2 = solve_part_2(input)
    puts "Solution2: #{solution2}"
  end
end
