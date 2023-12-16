# frozen_string_literal: true
$directions_hash = {
  'N' => [-1, 0],  # Move up (north)
  'W' => [0, -1],  # Move left (west)
  'S' => [1, 0],   # Move down (south)
  'E' => [0, 1] # Move right (east)
}

class Cell 
  attr_accessor :coords, :direction 

  def initialize(coords, direction)
    @coords = coords
    @direction = direction
  end

  def next_cell()
    Cell.new(@coords.zip($directions_hash[@direction]).map{|a,b| a +b}, @direction)
  end

  def advance()

  end

  def move(direction)
    coords =  @coords.zip($directions_hash[direction]).map{|a,b| a +b}
    Cell.new(@coords.zip($directions_hash[direction]).map{|a,b| a +b}, direction)
  end

  def inside?(matrix)
     @coords.first>= 0 &&  @coords.first < matrix.length && @coords.last>= 0 &&  @coords.last < matrix.first.length
  end

  def eql?(other)
    return false unless other.is_a?(Cell)

    @coords == other.coords && @direction == other.direction
  end

  def hash
    [@coords, @direction].hash
  end

end 

# Solve AoC puzzle for the day 16 2023
class Puzzle2023day16
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text

  end

  def parse_input(original)
    parsed = original.chomp
    original.lines.map {|l| l.chomp.split("")}
  end

  def part1(input)
    res = 0

  
  
  

    initial = Cell.new([0,0],'E')
    visited = Set.new
    q = [initial]
    while !q.empty? 
      p q.map{ |a| a.coords}
      current =  q.shift
      p " C #{current.coords} "

      next if !current.inside?(input)
      visited.add current
      next_cell = current.next_cell
      next if visited.include?(next_cell)
      p " n #{next_cell.coords} "


      e = input.dig(*(next_cell.coords))
      next if e.nil?
      case e 
      when "|"
       # if ["E","W"].any? { |a| a == next_cell.direction }
          #push north 
          q.push next_cell.move("N")
          #push south
          q.push next_cell.move("S")
        #end
      when "-"
        #if ["N","S"].any? { |a| a == next_cell.direction }
          #push north 
          q.push next_cell.move("E")
          #push south
          q.push next_cell.move("W")
        #end
      when "."
        q.push next_cell
      when "/"

        if next_cell.direction == "W"
          q.push next_cell.move("S")

        elsif next_cell.direction == "E"
          q.push next_cell.move("N")
        elsif next_cell.direction == "N"
          q.push next_cell.move("W")
        elsif next_cell.direction == "S"
          q.push next_cell.move("E")
        end
      when "\\"
        if next_cell.direction == "W"
          q.push next_cell.move("N")
        elsif next_cell.direction == "E"
          q.push next_cell.move("S")
        elsif next_cell.direction == "N"
          q.push next_cell.move("E")
        elsif next_cell.direction == "S"
          q.push next_cell.move("W")
        end
      end
      visited.add next_cell
      

    end
    coords = visited.map{ |a| a.coords}
    p coords
    x = ""
    input.each_with_index do |row,i|
      row.each_with_index do |col,j|
        x+=( coords.include?([i,j]) ? "#" : ".")
      end
      x +="\n"
    end
    p x.to_s
    visited.size
  end

  def part2(input)
    res = 0

    res
  en

  def run()
    
    tests()
    return
    puts "🎄 Puzzle 2023 16"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def tests()
    test = ".|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|...."
    e1 = 46
    a1 = part1 parse_input(test)
    p "#{e1} == a:#{a1}"

  end
end
