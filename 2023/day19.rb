# frozen_string_literal: true
RATE = { "x" => 0, "m" => 1, "a" => 2, "s" => 3 }
# Solve AoC puzzle for the day 19 2023

class Workflow
  attr_accessor :ranges

  def initialize(name, instructions)
    @name = name
    pattern = /(\w+)([<>])(\d+):(\w+)/
    @instructions = instructions.map { |i|
      m = i.scan(pattern)

      if m.empty?
        i
      else
        m.flatten
      end
    }
    @ranges = instructions.map { |i|
      m = i.split(":")
    }
  end

  def eval(rating)
    @instructions.each { |i|
      return i if i.is_a?(String)
      a = rating[RATE[i.first]]
      operator = i[1]
      n = i[2].to_i
      rule = case operator
        when "<"
          a < n
        when ">"
          a > n
        end
      return i[3] if rule
    }
  end

  def expand(workflow)
    @ranges.map { |r|
      if r[-1] != "A" && r[-1] != "R"
        r[-1] = workflow[r[-1]].expand workflow
      end
      r
    }
  end
end

class Puzzle2023day19
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.chomp
    a, b = parsed.split("\n\n")

    r = /(\w+)\{(.*)\}/
    r2 = /\{(.*)\}/
    ws = a.lines.map { |l| l.scan(r).flatten }.map { |c| [c.first, c.last.split(",")] }
    ratings = b.lines.map { |l| c = l.scan(/\b([^,]+)\b/).flatten.map { |c| c.split("=").last.to_i } }
    workflows = {}
    ws.each do |w|
      workflows[w.first] = Workflow.new(w.first, w.last)
    end
    [workflows, ratings]
  end

  def part1(input)
    worklfows, ratings = input

    res = 0
    ratings.each do |r|
      if is_accepted(r, worklfows)
        res += r.inject(:+)
      end
    end

    res
  end

  def is_accepted(r, workflows)
    current = "in"
    p

    loop do
      case current
      when "R"
        return false
      when "A"
        return true
      else
        current = workflows[current].eval(r)
      end
    end

    true
  end

  def part2(input)
    workflows, _ = input

    range = 4001
    min = 0
    current = "in"

    w = workflows[current]
    p "E"
    p w.ranges
    all = w.expand workflows
    p all
    min = Array.new(4, min)
    max = Array.new(4, range)

    res = follow(all, min, max)
  end

  def followT(all, lvl = 0)
    res = ""
    if "A" == all
      return "-A"
    elsif "R" == all
      return "-R"
    end
    all.each do |e|
      if e.first.is_a?(String)
        res += "L#{lvl} #{e.first} && "
        res += followT(e.last, lvl + 1)
        res += "\n"
      else
        res += followT(e, lvl + 1)
      end
    end
    res
  end

  def follow(all, min, max)
    res = 0
    if "A" == all
      p "min #{min} #{max} "
      p "END #{max.zip(min).map { |a, b| a - b - 1 }.inject(:*)}"
      return max.zip(min).map { |a, b| a - b - 1 }.inject(:*)
    elsif "R" == all
      return 0
    end
    all.each do |e|
      puts "E #{e.first} |  #{e.last} \nall #{all} \n#{min} #{max} "
      if e.first.is_a?(String)
        # Of the form x<123:A,node
        pattern = /(\w+)([<>])(\d+)/
        m = e.first.scan(pattern).flatten
        puts m.inspect
        g = RATE[m[0]] # index of  xmas
        min_copy = min.clone
        max_copy = max.clone
        num = m[2].to_i
        p num
        case m[1]
        when "<"
          max_copy[g] = num
          min[g] = num - 1
        when ">"
          min_copy[g] = num
          max[g] = num + 1
        end
        res += follow(e.last, min_copy, max_copy)
      else
        res += follow(e, min, max)
      end
    end
    res
  end

  def run()
    puts "🎄 Puzzle 2023 19"
    test
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def test
    t = "px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}"

    e2 = 167409079868000
    a2 = part2(parse_input(t))
    raise "e #{e2} != a #{a2}" unless e2 == a2
  end
end
