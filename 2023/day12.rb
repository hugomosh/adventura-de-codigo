class Puzzle2023day12
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.chomp
    parsed = original.lines.map { |l|
      a, b = l.split(" ")
      [a, b.split(",").map(&:to_i)]
    }
    parsed
  end

  def part1(input)
    res = 0
    for l in input
      res += arrengments_naive(*l)
    end
    res
  end

  def arrengments_naive(str, values)
    indices = []
    str.chars.each_index do |index|
      indices << index if str[index] == "?"
    end
    res = 0
    for r in 0..(2 ** indices.length) - 1
      binary_representation = r.to_s(2).rjust(indices.length, "0")
      copy = str.dup
      indices.each_with_index do |c, i|
        copy[c] = binary_representation[i] == "0" ? "." : "#"
      end

      if is_valid(copy, values)
        #  puts " #{copy} #{copy.split(/\.+/).reject(&:empty?)} "
        res += 1
      end
    end
    res
  end

  def arrengments(str, values)
    0
  end

  def is_valid(str, values)
    str.split(/\.+/).reject(&:empty?).map { |x| x.length } == values
  end

  def part2(input)
    res = 0
    for l in input
      a, b = l
      res += arrengments_naive((a + "?") * 5, b * 5)
    end
    res
  end

  def run()
    puts "🎄 Puzzle 2023 12"
    tests()
    input = parse_input(@original_text)
    # solution1 = part1(input)
    #  puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def tests()
    t1 = "???.### 1,1,3
    ????.#...#... 4,1,1 
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1"
    e1 = 21
    e2 = 525152
    actual1 = part1(parse_input(t1))
    if e1 == actual1
      puts "T1 ✅ e:#{e1} a:#{actual1}"
    else
      puts "T1 ❌  e:#{e1} a:#{actual1}"
    end
    actual2 = part2(parse_input(t1))
    if e2 == actual2
      puts "T2 ✅ e:#{e2} a:#{actual2}"
    else
      puts "T2 ❌  e:#{e2} a:#{actual2}"
    end
  end
end
