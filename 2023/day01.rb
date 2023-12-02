class Puzzle2023day01
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input()
  end

  def solve_part_1(input)
    sum = 0

    input.lines.each do |line|
      i = 0
      j = line.size - 1
      while !is_digit?(line[i])
        i += 1
      end
      while !is_digit?(line[j])
        j -= 1
      end
      number = line[i] + line[j]
      sum += number.to_i
    end

    sum
  end

  def solve_part_1_variant_2(input)
    sum = 0

    input.lines.each do |line|
      scan = line.scan(/[0-9]/)
      number = to_value(scan.first).to_s + to_value(scan.last).to_s
      sum += number.to_i
    end
    sum
  end

  def solve_part_2(input)
    sum = 0

    # one|two|three|four|five|six|seven|eight|nine
    input.lines.each do |line|
      # The main part of the challenge is to get all possilbe "digits" including the overlapping ones.
      # For example 'sevenine'
      scan = line.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|[0-9]))/).flatten
      number = to_value(scan.first).to_s + to_value(scan.last).to_s
      sum += number.to_i
    end
    # not 56322
    sum
  end

  def run()
    input = @original_text
    solution1 = solve_part_1(input)
    puts "Solution1: #{solution1}"
    solution2 = solve_part_2(input)
    puts "Solution2: #{solution2}"
  end

  def is_digit?(s)
    code = s.ord
    "0".ord <= code && code <= "9".ord
  end

  $text_digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

  def to_value(text)
    if is_digit? text
      return text.to_i
    elsif $text_digits.include?(text)
      return $text_digits.index(text) + 1
    else
      puts text
      throw "BAD INPUT "
    end
  end
end
