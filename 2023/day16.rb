# frozen_string_literal: true
$directions_hash = {
  "N" => [-1, 0],  # Move up (north)
  "W" => [0, -1],  # Move left (west)
  "S" => [1, 0],   # Move down (south)
  "E" => [0, 1], # Move right (east)
}

class Cell
  attr_accessor :coords, :direction

  def initialize(coords, direction)
    @coords = coords
    @direction = direction
  end

  def next_cell()
    Cell.new(@coords.zip($directions_hash[@direction]).map { |a, b| a + b }, @direction)
  end

  def advance()
  end

  def move(direction)
    coords = @coords.zip($directions_hash[direction]).map { |a, b| a + b }
    Cell.new(@coords.zip($directions_hash[direction]).map { |a, b| a + b }, direction)
  end

  def inside?(matrix)
    @coords.first >= 0 && @coords.first < matrix.length && @coords.last >= 0 && @coords.last < matrix.first.length
  end

  def eql?(other)
    return false unless other.is_a?(Cell)

    @coords == other.coords && @direction == other.direction
  end

  def hash
    [@coords, @direction].hash
  end

  def is_frontier?(input)
    return coords.first == 0 || coords.first == input.size - 1 || coords.last == 0 || coords.last == input.first.size - 1
  end

  def direction_edge?(input)
    return current.next_cell.inside?(input)
  end
end

# Solve AoC puzzle for the day 16 2023
class Puzzle2023day16
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
    @global_edeges = Set.new
  end

  def parse_input(original)
    parsed = original.chomp
    original.lines.map { |l| l.chomp.split("") }
  end

  def ray(starting_cell, input)
    visited = Set.new
    q = [starting_cell]
    while !q.empty?
      current = q.shift
      next if visited.include? current
      next if !current.inside?(input)
      visited.add current
      if !current.next_cell.inside? input
        @global_edeges.add current.coords
      end
      # puts "Current #{current.coords} #{input.dig(*(current.coords))} #{current.direction}"
      e = input.dig(*(current.coords))
      next if e.nil?

      case e
      when "|"
        # if ["E","W"].any? { |a| a == next_cell.direction }
        #push north
        q.push current.move("N")
        #push south
        q.push current.move("S")
        #end
      when "-"
        #if ["N","S"].any? { |a| a == current.direction }
        #push north
        q.push current.move("E")
        #push south
        q.push current.move("W")
        #end
      when "."
        q.push current.next_cell
      when "/"
        if current.direction == "W"
          q.push current.move("S")
        elsif current.direction == "E"
          q.push current.move("N")
        elsif current.direction == "N"
          q.push current.move("E")
        elsif current.direction == "S"
          q.push current.move("W")
        end
      when "\\"
        if current.direction == "W"
          q.push current.move("N")
        elsif current.direction == "E"
          q.push current.move("S")
        elsif current.direction == "N"
          q.push current.move("W")
        elsif current.direction == "S"
          q.push current.move("E")
        end
      end
    end
    coords = visited.map { |a| a.coords }
    coords.uniq.size
  end

  def part1(input)
    initial = Cell.new([0, 0], "E")
    ray(initial, input)
  end

  def part2(input)
    res = 0
    cells_to_try = []
    for x in 0...input.size
      cells_to_try.push Cell.new([x, 0], "E")
      cells_to_try.push Cell.new([x, input.first.size - 1], "W")
    end
    for y in 0...input.first.size
      cells_to_try.push Cell.new([0, y], "S")
      cells_to_try.push Cell.new([input.size - 1, y], "N")
    end

    max = 0
    while !cells_to_try.empty?
      c = cells_to_try.shift()
      next if @global_edeges.include? (c.coords)
      # Skip c is already globally visited in that direction
      n = ray(c, input)
      # puts "#{n} #{c.coords}"
      max = [max, n].max
    end
    # cells_to_try.map { |c| ray(c, input) }.max
    max
  end

  def print_m(input, coords)
    x = ""
    input.each_with_index do |row, i|
      row.each_with_index do |col, j|
        x += (coords.include?([i, j]) ? "#" : ".")
      end
      x += "\n"
    end
    puts x
  end

  def run()
    tests()
    puts "🎄 Puzzle 2023 16"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
    return
  end

  def tests()
    test = ".|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|...."
    e1 = 46
    a1 = part1 parse_input(test)
    p "#{e1} == a:#{a1}"
    e2 = 51
    a2 = part2 parse_input(test)
    p "#{e2} == a:#{a2}"
  end
end
