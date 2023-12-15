# frozen_string_literal: true

# Solve AoC puzzle for the day 15 2023
class Puzzle2023day15
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    original.chomp.lines.map { |l| l.split(',') }.first
  end

  def part1(input)
    res = 0
    input.each do |x|
      res += hash(x)
    end
    res
  end

  def hash(str)
    res = 0
    str.each_grapheme_cluster do |c|
      res += c.ord
      res = res * 17 % 256
    end
    res
  end

  def part2(input)
    boxes = {}
    res = 0
    input.each do |x|
      if x.include? '='
        label, num = x.split('=')
        box = hash(label)
        boxes[box] ||= []
        index = boxes[box].index { |e| e.first == label }
        if !index.nil?
          boxes[box][index] = [label, num.to_i]
        else
          boxes[box] << [label, num.to_i]
        end
      else
        x.slice!(-1)
        box = hash(x)
        boxes[box] ||= []
        index = boxes[box].index { |e| e.first == x }
        boxes[box].delete_at index unless index.nil?
      end
    end
    boxes.each do |k, v|
      result = v.each_with_index.reduce(0) do |sum, (value, index)|
        sum + (value.last * (index + 1))
      end
      res += result * (k + 1)
    end
    res
  end

  def run
    puts '🎄 Puzzle 2023 15'
    test
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def test
    t1 = 'rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7'
    a1 = part1(parse_input(t1))
    e1 = 1320
    puts "#{a1} #{e1}"
    a2 = part2(parse_input(t1))
    e2 = 145
    puts "#{a2} #{e2}"
  end
end
