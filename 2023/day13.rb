# frozen_string_literal: true

# Solve AoC puzzle for the day 1("3 2023
class Puzzle2023day13
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.chomp.split("\n\n").map { |e| Grid.new e.split("\n") }
  end

  def part1(input)
    res = 0

    input.each do |m|
      puts m.to_s
      s = m.find_symmetry
      puts s.inspect
      res += s.first * 100 + s.last
    end
    res
  end

  def part2(input)
    res = 0

    input.each do |m|
      puts m.to_s
      s = m.find_symmetry_smude

      puts s.inspect
      res += s.first * 100 + s.last
    end
    res
  end

  def run()
    puts "🎄 Puzzle 2023 13"
    test
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def test
    t = "#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"
    e1 = 405
    a1 = part1(parse_input(t))
    raise "Test! #{e1} != a:#{a1}" if e1 != a1
    e2 = 400
    a2 = part2(parse_input(t))
    raise "Test! #{e2} != a:#{a2}" if e2 != a2
  end
end

class Grid
  def initialize(matrix)
    @matrix = matrix
    @height = matrix.size
    @width = matrix.first.size
  end

  def find_symmetry()
    (1...@height).each do |row|
      row_down = row
      row_up = row_down - 1

      while row_up >= 0 && row_down < @height && @matrix[row_up] == @matrix[row_down]
        row_up -= 1
        row_down += 1
      end

      if row_up < 0 || row_down == @height
        # puts "R #{row}: #{row_up} #{row_down} "
        return [row, 0]
      end
    end

    (1...@width).each do |col|
      col_left = col - 1
      col_right = col

      while col_left >= 0 && col_right < @width && get_col(@matrix, col_left) == get_col(@matrix, col_right)
        col_right += 1
        col_left -= 1
      end
      if col_left < 0 || col_right == @width
        #  puts "C #{col}: #{col_right} #{col_right} "
        return [0, col]
      end
    end

    [0, 0]
  end

  def diff(s1, s2)
    res = 0
    s1.each_char.with_index do |c1, i|
      res += 1 if c1 != s2[i]
    end
    res
  end

  def find_symmetry_smude()
    (1...@height).each do |row|
      smudge = 0
      row_down = row
      row_up = row_down - 1

      while row_up >= 0 && row_down < @height
        if @matrix[row_up] != @matrix[row_down]
          diff = diff(@matrix[row_up], @matrix[row_down])
          if diff != 1
            smudge = 9
            break
          else
            smudge += 1
          end
        end

        row_up -= 1
        row_down += 1
      end

      if smudge == 1 && (row_up < 0 || row_down == @height)
        #  puts "R #{row}: #{row_up} #{row_down} "
        return [row, 0]
      end
    end

    (1...@width).each do |col|
      smudge = 0
      col_left = col - 1
      col_right = col

      while col_left >= 0 && col_right < @width
        if get_col(@matrix, col_left) != get_col(@matrix, col_right)
          diff = diff(get_col(@matrix, col_left), get_col(@matrix, col_right))
          if diff != 1
            smudge = 9
            break
          else
            smudge += 1
          end
        end
        col_right += 1
        col_left -= 1
      end
      if smudge == 1 && (col_left < 0 || col_right == @width)
        # puts "C #{col}: #{col_right} #{col_right} "
        return [0, col]
      end
    end

    [0, 0]
  end

  def get_col(matrix, col)
    matrix.map { |row| row[col] }.join("")
  end

  def to_s
    @matrix.join("\n")
  end
end
