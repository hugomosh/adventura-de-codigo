class Puzzle2023day5
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.split("\n\n")
    parsed = parsed.map { |l| l.split(" ") }
    # @seeds = parsed[1][1, parsed[1].length - 1]
    @seeds = parsed[0][1..-1].map(&:to_i)
    @maps = []
    (1..parsed.length - 1).each do |i|
      @maps.push (Map.new(parsed[i]))
    end
    parsed
  end

  def to_location(s)
    res = s
    for map in @maps
      res = map.convert(res)
    end
    res
  end

  def part1(input)
    res = 0
    min = @seeds.map { |s| to_location(s) }
    puts min.to_s
    min.min
  end

  def part2(input)
    res = 0
    seeds = []
    @seeds.each_slice(2) do |a, b|
      seeds.concat (a..a + b - 1).to_a
    end
    min = seeds.map { |s| to_location(s) }
    min.min
  end

  def run()
    puts "🎄 Puzzle 2023 5"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def test
  end
end

class Map
  attr_accessor :from, :to, :ranges

  def initialize(list)
    @from, @to = list[0].split("-to-")
    @ranges = []
    (2..list.length - 1).step(3) do |i|
      a = list[i, 3].map(&:to_i)
      @ranges.push(Range.new(*a))
    end
  end

  def convert(source)
    i = 0
    while i < @ranges.length
      if (@ranges[i].source <= source && source <= @ranges[i].source_end)
        return source + @ranges[i].destination - @ranges[i].source
      end
      i += 1
    end
    source
  end
end

class Range
  attr_accessor :destination, :destination_end, :source, :source_end

  def initialize(destination, source, range)
    @destination = destination
    @destination_end = destination + range - 1
    @source = source
    @source_end = source + range - 1
    @range = range
  end
end
