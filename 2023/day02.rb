class Puzzle2023day02
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    original.lines.map { |line|
      s = line.scan(/Game (\d+): (.*)/)
      g = Game.new(s.first[0], s.first[1].split(";"))
    }
  end

  $limits = {
    "red" => 12,
    "green" => 13,
    "blue" => 14,
  }

  def solve_part_1(input)
    res = 0
    input.each do |game|
      is_possible = true
      game.sets.flatten.each_slice(2) do |pair|
        #12 red cubes, 13 green cubes, and 14 blue cubes
        if pair.first.to_i > $limits[pair.last]
          is_possible = false
          break
        end
      end
      if is_possible
        res += game.index.to_i
      end
    end

    res
  end

  def solve_part_2(input)
    res = 0

    input.each do |game|
      count = {
        "red" => 0,
        "green" => 0,
        "blue" => 0,
      }
      game.sets.flatten.each_slice(2) do |pair|
        count[pair.last] = [count[pair.last], pair.first.to_i].max
      end
      res += count.values.reduce(:*)
    end

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

test_input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"

class Game
  attr_accessor :index, :sets

  def initialize(index, sets)
    @index = index
    @sets = sets.map { |s| s.split(",").map { |c| c.rstrip.scan(/(\d+) (\w+)/).flatten } }
  end

  def to_s()
    puts @sets.to_s
  end
end
