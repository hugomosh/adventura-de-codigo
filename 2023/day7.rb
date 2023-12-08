class Puzzle2023day7
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
    @custom_order = { "A" => 14, "K" => 13, "Q" => 12, "J" => 11, "T" => 10, "9" => 9, "8" => 8, "7" => 7, "6" => 6, "5" => 5, "4" => 4, "3" => 3, "2" => 2 }
    @custom_order2 = { "A" => 14, "K" => 13, "Q" => 12, "J" => 1, "T" => 10, "9" => 9, "8" => 8, "7" => 7, "6" => 6, "5" => 5, "4" => 4, "3" => 3, "2" => 2 }
  end

  def parse_input(original)
    parsed = original
    parsed = original.lines.map { |l| l.split(" ") }
      .map { |l| l.push(rank(l[0]), rank2(l[0])) }
  end

  def part1(input)
    res = 0
    x = input.sort do |a, b|
      comparison = a[2][0] <=> b[2][0]
      comparison.zero? ? a.first.chars.map { |card| @custom_order[card] } <=> b.first.chars.map { |card| @custom_order[card] } : comparison
    end
    (1..x.length).step(1) do |i|
      e = x[i - 1]
      res += i * e[1].to_i
    end
    res
  end

  def rank(l)
    v = Hash.new(0)
    l.each_char { |c| v[c] += 1 }
    case v.values.sort
    when [5]
      [9, "Poker"]
    when [1, 4]
      [8, "Four of a Kind"]
    when [2, 3]
      [7, "Full House"]
    when [1, 1, 3]
      [4, "Three of a Kind"]
    when [1, 2, 2]
      [3, "Two Pair"]
    when [1, 1, 1, 2]
      [2, "One Pair"]
    else
      [1, "High Card"]
    end
  end

  def rank2(l)
    v = Hash.new(0)
    l.each_char { |c| v[c] += 1 }
    if v.has_key? "J"
      puts v.inspect
      number = v.delete "J"
      max_key, max_value = v.max_by { |key, value| [value, @custom_order[key]] }
      puts max_key, max_value
      max_key = "A" if max_key == nil
      v[max_key] += number
      puts v.inspect
    end

    case v.values.sort
    when [5]
      [9, "Poker"]
    when [1, 4]
      [8, "Four of a Kind"]
    when [2, 3]
      [7, "Full House"]
    when [1, 1, 3]
      [4, "Three of a Kind"]
    when [1, 2, 2]
      [3, "Two Pair"]
    when [1, 1, 1, 2]
      [2, "One Pair"]
    else
      [1, "High Card"]
    end
  end

  def part2(input)
    res = 0
    x = input.sort do |a, b|
      comparison = a.last[0] <=> b.last[0]
      comparison.zero? ? a.first.chars.map { |card| @custom_order2[card] } <=> b.first.chars.map { |card| @custom_order2[card] } : comparison
    end
    (1..x.length).step(1) do |i|
      e = x[i - 1]
      res += i * e[1].to_i
    end
    res
  end

  def run()
    puts "🎄 Puzzle 2023 7"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end
end
