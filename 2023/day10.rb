class Puzzle2023day10
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    parsed = original.chomp
    @map = original.lines.map { |l| l.chomp.split("") }
    parsed
  end

  def part1(input)
    res = 0
    s_i = nil
    @map.each_with_index do |row, row_i|
      row.each_with_index do |e, col_i|
        s_i = [row_i, col_i] if e == "S"
        break if s_i != nil
      end
      break if s_i != nil
    end
    puts s_i.inspect

    queue = [s_i]
    distances = { s_i => 0 }

    directions_hash = {
      "N" => [-1, 0],  # Move up (north)
      "S" => [1, 0],   # Move down (south)
      "W" => [0, -1],  # Move left (west)
      "E" => [0, 1],    # Move right (east)
    }

    neighbors = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    max_distance = 0
    while !queue.empty?
      current = queue.shift
      current_d = distances[current]
      max_distance = [max_distance, current_d].max
      directions_hash.each do |direction, n|
        n_i = current.zip(n).map { |a, b| a + b }

        next if !within_bounds(n_i, @map)
        #           puts "i #{n_i.inspect} , #{direction} #{n}"

        e = @map.dig(*n_i)
        if !distances.key?(n_i) && valid(@map.dig(*current), e, direction)
          # puts "From: #{@map.dig(*current)} to: #{e} d: #{direction}"
          #puts "C:#{current_d} From: #{@map.dig(*current)} to: #{e} N_I:#{n_i} d: #{direction}, v : #{valid(@map.dig(*current), e, direction)}"
          # puts "valid"
          distances[n_i] = current_d + 1
          queue.push n_i
        end
      end
    end

    puts max_distance
    countInside = 0
    countOutside = 0
    countFrontier = 0
    s = ""
    mapping2 = {
      "|" => "|",
      "F" => "┌",
      "J" => "┘",
      "7" => "┐",
      "L" => "└",
      "-" => "-",
      "S" => "S",
    }
    mapping = {
      "|" => "║",
      "F" => "╔",
      "J" => "╝",
      "7" => "╗",
      "L" => "╚",
      "-" => "═",
      "S" => "S",
    }
    @map.each_with_index do |row, i|
      cross = 0
      prev = nil
      row.each_with_index do |_, j|
        current = [i, j]
        if distances.key?(current)
          border = @map.dig(*current)
          s += mapping[@map.dig(*current)].to_s
          if ["|", "S", "F", "7"].any? { |x| x == @map.dig(*current) }
            cross += 1
          end
          next
          case border
          when "S"
            cross += 1
            prev = nil
          when "|"
            cross += 1
            prev = nil
          when "F"
            if prev == "J"
              cross += 1
              prev = nil
            elsif prev == "7"
              prev = nil
            else
              prev = "F"
            end
          when "L"
            if prev == "7"
              cross += 1
              prev = nil
            elsif prev == "J"
              prev = nil
            else
              prev = "L"
            end
          when "J"
            if prev == "F"
              cross += 1
              prev = nil
            elsif prev == "L"
              prev = nil
            else
              prev = "J"
            end
          when "7"
            if prev == "L"
              cross += 1
              prev = nil
            elsif prev == "F"
              prev = nil
            else
              prev = "7"
            end
          end
          # if ["|", "F", "J", "7", "L"].any? { |x| x == @map.dig(*current) }
          #   cross += 1
          # end
        else
          if cross % 2 == 1
            s += "I" #cross.to_s(16)
            countInside += 1
          else
            s += "O"
            countOutside += 1
          end
        end
      end
      s += "\n"
    end
    puts s.to_s
    puts "I: #{countInside} o: #{countOutside} .V#{countFrontier} #{distances.size}"
    num_rows = @map.length
    num_cols = @map.empty? ? 0 : @map[0].length
    puts num_rows * num_cols
    puts countInside + countOutside + countFrontier
  end

  def valid(from, to, direction)
    return false if to == "." || to == "S"
    directions_hash = {
      "N" => { "to" => ["|", "7", "F"], "from" => ["|", "J", "L", "S"] },
      "S" => { "to" => ["|", "J", "L"], "from" => ["|", "F", "7", "S"] },
      "W" => { "to" => ["-", "F", "L"], "from" => ["-", "7", "J", "S"] },
      "E" => { "to" => ["-", "7", "J"], "from" => ["-", "F", "L", "S"] },
    }
    return directions_hash[direction]["to"].any? { |x| x == to } &&
             directions_hash[direction]["from"].any? { |x| x == from }
    valid_connections = [
      ["-", "-", "E"],
      ["-", "-", "W"],
      ["-", "7", "E"],
      ["-", "F", "W"],
      ["-", "J", "E"],
      ["-", "L", "W"],
      ["|", "|", "N"],
      ["|", "|", "S"],
      ["|", "7", "N"],
      ["|", "F", "N"],
      ["|", "J", "S"],
      ["|", "L", "S"],
      ["7", "-", "W"],
      ["7", "|", "S"],
      ["7", "F", "W"],
      ["7", "J", "S"],
      ["7", "L", "W"],
      ["F", "-", "E"],
      ["F", "|", "S"],
      ["F", "7", "E"],
      ["F", "J", "S"],
      ["F", "J", "E"],
      ["J", "-", "W"],
      ["J", "|", "N"],
      ["J", "7", "N"],
      ["J", "F", "N"],
      ["J", "F", "W"],
      ["J", "L", "W"],
      ["L", "-", "E"],
      ["L", "|", "N"],
      ["L", "7", "E"],
      ["L", "J", "E"],
      ["S", "-", "E"],
      ["S", "-", "W"],
      ["S", "|", "N"],
      ["S", "|", "S"],
      ["S", "7", "E"],
      ["S", "F", "W"],
      ["S", "J", "E"],
      ["S", "L", "W"],
    ]
    return valid_connections.any? { |c| c == [from, to, direction] }
  end

  def within_bounds(i, matrix)
    num_rows = matrix.length
    num_cols = matrix.empty? ? 0 : matrix[0].length
    bounds = [num_rows, num_cols]
    i.each_with_index.all? { |v, index|
      v >= 0 && v < bounds[index]
    }
  end

  def part2(input)
    res = 0

    res
  end

  def run()
    puts "🎄 Puzzle 2023 10"
    input = parse_input(@original_text)
    solution1 = part1(input)
    puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end
end
