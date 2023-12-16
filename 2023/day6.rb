class Puzzle2023day6
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
    @time, @distance = original_text.lines.map { |l| l.scan(/(\d+)/).flatten.map(&:to_i) }
    puts @time.to_s, @distance.to_s
  end

  def parse_input(original)
    parsed = original
    original.lines { |l| l.split(" ") }
    parsed
  end

  def part1(input)
    res = 0
    options = []
    (0..@time.length - 1).step(1) do |i|
      t = @time[i]
      d = @distance[i]
      min_speed = 0
      while min_speed * (t - min_speed) <= d
        min_speed += 1
      end

      max_speed = t
      while max_speed * (t - max_speed) <= d
        max_speed -= 1
      end
      options.push (max_speed - min_speed + 1)
    end

    options.reduce(1) { |total, c| total * c }
  end

  def part2(input)
    res = 0
    time = @time.join("").to_i
    distance = @distance.join("").to_i

    puts time, distance

    min_speed = 0
    while min_speed * (time - min_speed) <= distance
      min_speed += 1
    end

    max_speed = time
    while max_speed * (time - max_speed) <= distance
      max_speed -= 1
    end
    (max_speed - min_speed + 1)
  end

  def run()
    puts "🎄 Puzzle 2023 6"""    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end
enend
d
end
