class Puzzle2023day4
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
    @cards = []
  end

  def parse_input(original)
    parsed = original

    original.lines.map { |l|
      s = l.scan(/Card\s+(\d+):(.*)/)[0]
      numbers = s[1].split("|").map { |n| n.split(" ").map(&:to_i) }
      @cards.push Card.new(s[0].to_i, numbers.first, numbers.last)
    }
    parsed
  end

  def solve_part_1(input)
    res = 0
    @cards.each do |card|
      res += 2 ** (card.intersection().size - 1) if card.intersection().size >= 1
    end
    res
  end

  def solve_part_2(input)
    res = 0

    @cards.each do |card|
      next if card.intersection().size == 0
      intersection = card.intersection().size
      for n in (card.index..card.index + intersection - 1)
        @cards[n].copies = @cards[n].copies + card.copies
      end
    end
    @cards.reduce(0) { |sum, card| sum + card.copies }
  end

  def run()
    puts "🎄 Puzzle 2023 4"
    input = parse_input(@original_text)
    solution1 = solve_part_1(input)
    puts "Solution 1: #{solution1}"
    solution2 = solve_part_2(input)
    puts "Solution2: #{solution2}"
  end
end

class Card
  attr_accessor :index, :copies

  def initialize(index, winning, numbers)
    @index = index
    @winning = winning
    @numbers = numbers
    @copies = 1
  end

  def intersection()
    winningSet = Set.new @winning
    numbersSet = Set.new @numbers
    (winningSet & numbersSet)
  end

  def to_s()
    puts "#%d copies:%d" % [@index, @copies]
  end
end
