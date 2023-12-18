# frozen_string_literal: true

class PriorityQueue
end

DIRECTIONS_HASH = {
  "N" => [-1, 0],  # Move up (north)
  "W" => [0, -1],  # Move left (west)
  "S" => [1, 0],   # Move down (south)
  "E" => [0, 1],   # Move right (east)
}

OPOSITE_DIRECTIONS = {
  "N" => "S",
  "W" => "E",
  "S" => "N",
  "E" => "W",
}

class Cell
  attr_accessor :coords

  def initialize(coords)
    @coords = coords
  end

  def neighbors()
    DIRECTIONS_HASH.values.map { |d| Cell.new @coords.zip(d).map(&:sum) }
  end

  def inside?(matrix)
    @coords.first >= 0 && @coords.first < matrix.length && @coords.last >= 0 && @coords.last < matrix.first.length
  end

  def to_s()
    "C #{coords}"
  end
end

class Node < Cell
  attr_accessor :cost, :came_from, :direction, :distance_in_direction

  def initialize(coords, came_from = nil, direction = nil, distance_in_direction = nil, cost = 0)
    @coords = coords
    @came_from = came_from
    @direction = direction
    @distance_in_direction = !distance_in_direction.nil? ? distance_in_direction : 0
    @cost = cost
  end

  def neighbors(input)
    DIRECTIONS_HASH.map { |d_name, d|
      new_distance = @direction == d_name ? @distance_in_direction + 1 : 0
      new_coords = coords.zip(d).map(&:sum)

      if input.dig(*new_coords).nil?
        nil
      else
        Node.new(new_coords, self, d_name, new_distance, input.dig(*new_coords) + @cost)
      end
    }
  end

  def eql?(other)
    return false unless other.is_a?(Node)

    @coords == other.coords && @direction == other.direction && @distance_in_direction == other.distance_in_direction
  end

  def hash
    [@coords, @direction, @distance_in_direction].hash
  end

  def to_s()
    "C #{coords}, cost: #{cost}, direction:  #{direction}, #{distance_in_direction},"
  end
end

# Solve AoC puzzle for the day 17 2023
class Puzzle2023day17
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.chomp
    original.lines.map { |l| l.chomp.split("").map(&:to_i) }
  end

  def part1(input)
    res = 0
    starting_point = Node.new [0, 0]
    paths = []
    destination = Node.new [input.length - 1, input.first.length - 1]
    shortest_path = shortest_path(input, starting_point, destination)
    res
  end

  def shortest_path(input, start, end_cell)
    current = start
    frontier = [current]
    expanded = Set.new
    while current.coords != end_cell.coords && !frontier.empty?
      frontier.sort! { |a, b| a.cost - b.cost }
      current = frontier.shift()
      expanded << current
      for x in current.neighbors(input).filter { |a| 
        !a.nil? && a.inside?(input) && a.direction != OPOSITE_DIRECTIONS[current.direction] && a.distance_in_direction <= 3 }
        f_ind = frontier.index { |f| x.eql? f }
        if !expanded.include?(x) && f_ind.nil?
          puts "#{current.to_s} -> #{x.to_s} #{f_ind}"
          frontier << x
        elsif !f_ind.nil?
          frontier[f_ind].cost < x.cost
          frontier[f_ind] = x
        end
      end
    end
    puts "F"
    puts current.to_s
  end

  def part2(input)
    res = 0

    res
  end

  def run
    test()

    puts "🎄 Puzzle 2023 17"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    return
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def test
    test = "2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533"
    a1 = part1(parse_input(test))
    e1 = 102
    puts "#{a1} == #{e1}"
  end
end
