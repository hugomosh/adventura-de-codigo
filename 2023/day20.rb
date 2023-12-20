# frozen_string_literal: true
LOW = false
HIGH = true
# Solve AoC puzzle for the day 20 2023
class Puzzle2023day20
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    Module.reset
    parsed = original.chomp
    original.lines.map { |l| l.chomp.split(" -> ") }.map { |e| Module.new(e) }
    Module.link_modules
    Module.shared_map
  end

  def part1(input)
    res = 0

    current = "broadcaster"
    pulse = LOW
    lows = 0
    highs = 0
    (1..1000).each do |i|
      #  puts "+#{i}" + "-" * 20
      queue = [["button", "broadcaster", LOW]]
      while !queue.empty?
        origin, current, pulse = queue.shift
        #  puts "#{origin} -#{pulse}--> #{current} "
        if pulse
          highs += 1
        else
          lows += 1
        end
        next if Module.shared_map[current].nil?
        list = Module.shared_map[current].broadcast(origin, pulse)
        queue.concat list
      end
    end
    puts "#{lows} highs: #{highs}"

    res = lows * highs
  end

  def part2(input)
    res = 0

    current = "broadcaster"
    pulse = LOW
    lows = 0
    highs = 0
    i = 0
    sol = {}
    loop do
      i += 1
      return 0 if i == 10 ** 5
      #print "\e[2J"
      queue = [["button", "broadcaster", LOW]]
      while !queue.empty?
        origin, current, pulse = queue.shift

        if pulse == LOW && ["vt", "sk", "xc", "kk"].include?(current)
          sol[current] = i
          puts "+#{i}" + "-" * 20
          puts "#{origin} -#{pulse}--> #{current} "
          puts sol
        end

        if sol.size == 4
          return sol.values.inject(:lcm)
        end
        next if Module.shared_map[current].nil?
        list = Module.shared_map[current].broadcast(origin, pulse)
        queue.concat list
      end
    end
    puts "#{lows} highs: #{highs}"

    res = lows * highs
  end

  def run()
    puts "🎄 Puzzle 2023 20"
    test
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"

    input = parse_input(@original_text)
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def test
    t0 = "broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a"
    e0 = 32000000
    # a0 = part1(parse_input(t0))
    # raise "e0 #{e0} != a #{a0}" unless e0 == a0
    t = "broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output"
    e1 = 11687500
    #  a1 = part1(parse_input(t))
    # raise "e1 #{e1} != a #{a1}" unless e1 == a1
  end
end

class Module
  attr_accessor :name, :list, :state, :type, :inputs

  @@shared_map = {}
  @@stack = []

  def initialize(arr)
    case arr[0][0]
    when "%"
      @name = arr[0][1..-1]
      @type = "%"
      @state = LOW
    when "&"
      @name = arr[0][1..-1]
      @type = "&"
      @inputs = {}
=begin 
  ..they initially default to remembering a low pulse for each input. 
  When a pulse is received, the conjunction module first updates its memory for that input. 
  Then, if it remembers high pulses for all inputs, it sends a low pulse; otherwise, it sends a high pulse.
=end
    else
      @type = "button"
      @name = arr[0]
    end

    @state = false #on - off
    @list = arr.last.split(", ")
    @@shared_map[@name] = self
  end

  def self.shared_map
    @@shared_map
  end

  def self.reset
    @@shared_map = {}
    @@stack = []
  end

  def self.link_modules
    @@shared_map.select { |k, v| v.type == "&" }.each { |k, v|
      @@shared_map.select { |k2, v2| v2.list.include?(v.name) }.each { |k2, v2|
        # puts "REla#{v.name} -> #{v2.name}"
        v.inputs[v2.name] = LOW
      }
    }
  end

  def broadcast(origin, pulse = LOW)
    case @type
    when "button"
      return @list.map { |l|
               [@name, l, pulse]
             }
    when "%"
      return [] if HIGH == pulse
      @state = !@state
      return @list.map { |l|
               [@name, l, @state]
             }
    when "&"
      @inputs[origin] = pulse
      r = @inputs.values.reduce(true) { |acc, value| acc && value }
      # puts "&#{@name} O:#{origin} p#{pulse} R:#{r} #{@inputs} List: #{@list}" if  ["vt","sk","xc","kk"].include? @name
      return @list.map { |l|
               [@name, l, !r]
             }
    end
  end
end
