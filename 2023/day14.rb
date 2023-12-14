class Puzzle2023day14
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text

    @directions_hash = {
      "N" => [-1, 0],  # Move up (north)
      "W" => [0, -1],  # Move left (west)
      "S" => [1, 0],   # Move down (south)
      "E" => [0, 1],    # Move right (east)
    }

    @directions_array = [[-1, 0], [0, -1], [1, 0], [0, 1]]
  end

  def parse_input(original)
    parsed = original.chomp
    parsed = original.lines.map { |l| l.chomp.split("") }
    parsed
  end

  def part1(input)
    res = 0
    puts input.inspect
    height = input.size
    input.each_with_index do |row, row_index|
      row.each_with_index do |element, col_index|
        case element
        when "O"
          i = row_index - 1
          j = col_index
          while i >= 0 && !["#", "0", "O"].any? { |e| e == input[i][j] }
            input[i][j] = "0"
            input[i + 1][j] = "-"
            i -= 1
          end
          res += height - i - 1
        end
      end
    end
    puts input.inspect
    puts "X"
    m = input.map do |row|
      row.join("")
    end
    puts m.join("\n")
    res
  end

  def part2(input)
    res = 0
    record = {}
    #nort ,west, south, east
    for c in 1..1000000000
      for d in [[-1, 0]] * 4
        input.each_with_index do |row, row_index|
          row.each_with_index do |element, col_index|
            case element
            when "O", "0"
              i, j = [row_index, col_index].zip(d).map { |a, b| a + b }
              while i >= 0 && i < input.size && j >= 0 && j < input.first.size && !["#", "0", "O"].any? { |e| e == input[i][j] }
                input[i][j] = "0"
                input[i - d.first][j - d.last] = "-"
                i, j = [i, j].zip(d).map { |a, b| a + b }
              end
            end
          end
        end

        input = rotate_matrix_90_deg(input)
      end

      m = input.map do |row|
        row.join("")
      end
      if record.include? m.join("\n")
        cycle = (1000000000 - c) % (c - record[m.join("\n")].first)
        puts "Cycle at: #{c} #{record[m.join("\n")].first} #{c - record[m.join("\n")].first}  #{1000000000 - c} #{cycle}"
        puts (1000000000 - c) % (c - record[m.join("\n")].first)

        res = record.values.find { |v| v.first == record[m.join("\n")].first + cycle }
        puts record[m.join("\n")].inspect
        puts record.values.inspect
        puts res.inspect
        return res.last
      else
        record[m.join("\n")] = [c, count_load(input)]
        height = input.size
        puts [c, count_load(input)].inspect
      end
    end
    res
  end

  def count_load(input)
    res = 0
    height = input.size

    input.each_with_index do |row, row_index|
      row.each_with_index do |element, col_index|
        case element
        when "O", "0"
          res += height - row_index
        end
      end
    end
    res
  end

  def rotate_matrix_90_deg(matrix)
    rows = matrix.length
    columns = matrix[0].length

    rotated_matrix = Array.new(columns) { Array.new(rows) }

    (0...rows).each do |i|
      (0...columns).each do |j|
        rotated_matrix[j][rows - 1 - i] = matrix[i][j]
      end
    end

    rotated_matrix
  end

  def run()
    puts "🎄 Puzzle 2023 14"
    test()
    input = parse_input(@original_text)
    # solution1 = part1(input)
    # puts "Part 1: #{solution1}"
    solution2 = part2(input)
    puts "Part 2: #{solution2}"
  end

  def test()
    t1 = "O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."
    e1 = 136
    #  actual1 = part1(parse_input(t1))
    # puts "Not #{e1} != #{actual1}" if e1 != actual1

    actual2 = part2(parse_input(t1))
    e2 = 64
    puts "Not #{e2} != #{actual2}"
  end
end
