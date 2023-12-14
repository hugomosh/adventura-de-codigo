class Puzzle2023day8
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original
    @instructions, @text = original.split("\n\n")
    @nodes = {}

    @text.lines { |l|
      n = (l.scan /(\w{3})/).flatten
      @nodes[n[0]] = n[1..]
    }
    puts @nodes.inspect
    parsed
  end

  def part1(input)
    res = 0
    current = "AAA"
    i = 0
    while current != "ZZZ"
      case @instructions[i % @instructions.length]
      when "R"
        current = @nodes[current].last
      when "L"
        current = @nodes[current].first
      end
      i += 1
    end
    res = i
  end

  def part2(input)
    res = 0
    keys = @nodes.keys.select { |key| key.end_with?("A") }
    puts keys
    mods = []
    for k in keys
      i = 0
      current = k
      while !current.end_with?("Z")
        case @instructions[i % @instructions.length]
        when "R"
          current = @nodes[current].last
        when "L"
          current = @nodes[current].first
        end
        i += 1
      end
      mods.push i
    end
    puts mods.inspect
    res
  end

  def run()
    puts "🎄 Puzzle 2023 8"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end
end
