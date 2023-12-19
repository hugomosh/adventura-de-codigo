# frozen_string_literal: true

DIRECTIONS_HASH = {
  "U" => [-1, 0],  # Move up (north)
  "L" => [0, -1],  # Move left (west)
  "D" => [1, 0],   # Move down (south)
  "R" => [0, 1],   # Move right (east)
}

# Solve AoC puzzle for the day 18 2023
class Puzzle2023day18
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.chomp
    original.lines.map { |l| l.chomp.split(" ") }
  end

  def part1(input)
    current = [0, 0]
    map = Set.new
    input.each do |plan|
      (1..plan[1].to_i).each do |x|
        current = current.zip(DIRECTIONS_HASH[plan.first]).map(&:sum)
        map << current
      end
    end

    max_x = map.map { |coord| coord.first }.max
    max_y = map.map { |coord| coord.last }.max
    min_x = map.map { |coord| coord.first }.min
    min_y = map.map { |coord| coord.last }.min

    matrix = Array.new (max_x - min_x + 1) { Array.new(max_y - min_y + 1, 0) }
    map.each { |r, c| matrix[r - min_x][c - min_y] = 1 }
    # Find point inside
    point_inside = nil

    matrix.each_with_index do |row, i|
      row.each_with_index do |e, j|
        if e == 1 && matrix[i + 1][j] == 0
          point_inside = [i + 1, j]
          break
        end
      end
      break if !point_inside.nil?
    end
    p point_inside
    # Flod fill that point and count area
    res = 0

    stack = [point_inside]
    visited = Set.new
    until stack.empty?
      coords = stack.pop
      next if !inside_matrix?(coords, matrix) || visited.include?(coords) || matrix.dig(*coords) == 1
      res += 1
      visited << coords
      stack.push.concat DIRECTIONS_HASH.values.map { |v| v.zip(coords).map(&:sum) }
    end
    res + map.size
  end

  def part2(input)
    current = [0, 0]
    map = Set.new
    dd = ["R", "D", "L", "U"]
    input.each do |plan|
      m = plan.last[2...7].to_i(16)
      d = dd[plan.last[8].to_i]
      (1..m).each do |x|
        current = current.zip(DIRECTIONS_HASH[d]).map(&:sum)
        map << current
      end
    end

    max_x = map.map { |coord| coord.first }.max
    max_y = map.map { |coord| coord.last }.max
    min_x = map.map { |coord| coord.first }.min
    min_y = map.map { |coord| coord.last }.min
    print max_x, min_y
    matrix = Array.new (max_x - min_x + 1) { Array.new(max_y - min_y + 1, 0) }
    map.each { |r, c| matrix[r - min_x][c - min_y] = 1 }
    print_matrix_to_file(matrix, "output.txt")
    # Find point inside
    point_inside = nil

    matrix.each_with_index do |row, i|
      row.each_with_index do |e, j|
        if e == 1 && matrix[i + 1][j] == 0
          point_inside = [i + 1, j]
          break
        end
      end
      break if !point_inside.nil?
    end
    p point_inside
    # Flod fill that point and count area
    res = 0

    stack = [point_inside]
    visited = Set.new
    until stack.empty?
      coords = stack.pop
      next if !inside_matrix?(coords, matrix) || visited.include?(coords) || matrix.dig(*coords) == 1
      res += 1
      visited << coords
      stack.push.concat DIRECTIONS_HASH.values.map { |v| v.zip(coords).map(&:sum) }
    end
    res + map.size
  end

  def run()
    puts "🎄 Puzzle 2023 18"
    test
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def test
    t = "R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)"
    e1 = 62
    a1 = part1(parse_input(t))
    raise "#{e1} != #{a1}" unless e1 == a1
    e2 = 952408144115
    a2 = part2(parse_input(t))
    raise "#{e2} != #{a2}" unless e2 == a2
  end
end

def print_matrix_to_file(matrix, file_name)
  File.open(file_name, "w") do |file|
    matrix.each do |row|
      file.puts row.join("")
    end
  end
end

def inside_matrix?(coords, matrix)
  coords.first >= 0 && coords.first < matrix.length && coords.last >= 0 && coords.last < matrix.first.length
end
