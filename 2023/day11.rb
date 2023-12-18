# frozen_string_literal: true

# Solve AoC puzzle for the day 11 2023
class Puzzle2023day11
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.chomp
    original.lines.map { |l| l.chomp.split("") }
  end

  def part1(input)
    res = 0
    unused_rows = Set.new 0...input.size
    unused_cols = Set.new 0...input.first.size
    galaxies = []
    input.each_with_index do |row, i|
      row.each_with_index do |e, j|
        case e
        when "#"
          galaxies << [i, j]
          unused_cols.delete j
          unused_rows.delete i
        when "."
        end
      end
    end
    galaxies.each_with_index do |g1, i|
      galaxies[i + 1..-1].each do |g2|
        res += distance(g1, g2, unused_rows, unused_cols)
      end
    end

    res
  end

  def distance(a, b, rows, cols, factor = 2)
    dx = a.first - b.first
    dy = a.last - b.last

    r = rows.select { |s| is_between(s, a.first, b.first) }
    c = cols.select { |s| is_between(s, a.last, b.last) }

    dx.abs - r.size + dy.abs - c.size + ((r.size + c.size) * factor)
  end

  def is_between(x, a, b)
    # Check if x is between a and b (inclusive), regardless of their order
    return (x >= a && x <= b) || (x >= b && x <= a)
  end

  def part2(input)
    res = 0
    unused_rows = Set.new 0...input.size
    unused_cols = Set.new 0...input.first.size
    galaxies = []
    input.each_with_index do |row, i|
      row.each_with_index do |e, j|
        case e
        when "#"
          galaxies << [i, j]
          unused_cols.delete j
          unused_rows.delete i
        when "."
        end
      end
    end
    galaxies.each_with_index do |g1, i|
      galaxies[i + 1..-1].each do |g2|
        res += distance(g1, g2, unused_rows, unused_cols, 1000000)
      end
    end

    res
  end

  def run()
    test
    puts "🎄 Puzzle 2023 11"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
    return
  end

  def test
    t = "...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."
    e1 = 374
    a1 = part1(parse_input(t))
    p "#{e1} == #{a1}"
    e2 = 82000210
    a2 = part2(parse_input(t))
    p "#{e2} == #{a2}"
  end
end
