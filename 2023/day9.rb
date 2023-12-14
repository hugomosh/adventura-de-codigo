class Puzzle2023day9
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.lines.map { |l| l.split(" ").map(&:to_i) }
    parsed
  end

  def part1(input)
    res = 0
    input.each { |i|
      x = extrapolate(i)
      res += x.first.last
    }
    res
  end

  def extrapolate(arr)
    subs = [arr]

    while !subs.last.all? { |element| element == 0 }
      prev = subs.last
      subs.push ([])
      sub = subs.last

      for i in 0..(prev.length - 2)
        a = prev[i]
        b = prev[i + 1]
        sub.push b - a
      end
    end
    subs.last.push 0
    for j in 1..(subs.length - 1)
      subs[-1 - j].push(subs[-1 - j].last + subs[-j].last)
    end

    subs
  end

  def extrapolate2(arr)
    subs = [arr]

    while !subs.last.all? { |element| element == 0 }
      prev = subs.last
      subs.push ([])
      sub = subs.last

      for i in 0..(prev.length - 2)
        a = prev[i]
        b = prev[i + 1]
        sub.push b - a
      end
    end
    subs.last.push 0
    for j in 1..(subs.length - 1)
      subs[-1 - j].unshift(subs[-1 - j].first - subs[-j].first)
    end
    subs
  end

  def part2(input)
    res = 0
    input.each { |i|
      x = extrapolate2(i)
      res += x.first.first
    }
    res
  end

  def run()
    puts "🎄 Puzzle 2023 9"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end
end
