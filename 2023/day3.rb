class Puzzle2023day3
  attr_accessor :original_text

  def initialize(original_text = nil)
    @original_text = original_text
  end

  def parse_input(original)
    original.split("\n").map { |l| l.split("") }
  end

  def solve_part_1(input)
    res = 0
    i = 0
    while i < input.length
      j = 0
      while j < input[i].length
        # Is a number
        if (/\d/.match input[i][j])
          # Get the whole number
          k = j
          while /\d/.match input[i][k + 1]
            k += 1
          end

          # find neighboards
          number = input[i][j..k].join("").to_i
          if has_adjacent_symbol(input, i, j, k)
            res += number
          end
          j = k
        end
        j += 1
      end
      i += 1
    end
    res
  end

  def solve_part_2(input)
    res = 0
    i = 0
    while i < input.length
      j = 0
      while j < input[i].length
        if ((/\*/).match(input[i][j]))
          n = get_neighboards(input, i, j)
          if n.length == 2
            res += n[0] * n[1]
          end
        end
        j += 1
      end
      i += 1
    end
    res
  end

  def has_adjacent_symbol(m, row, col, col_end)
    for x in (row - 1..row + 1)
      next if x < 0 || x == m.length

      for y in (col - 1..col_end + 1)
        next if y < 0 || y == m[0].length

        return true if ((/[^0-9.]/).match(m[x][y]))
      end
    end
    false
  end

  def get_neighboards(m, row, col)
    res = []
    ind = []
    for x in (row - 1..row + 1)
      next if x < 0 || x == m.length
      for y in (col - 1..col + 1)
        if (/\d/.match m[x][y])
          ind.push [x, y]
        end
      end
    end

    visited = []

    for i in ind
      next if visited.include?(i)
      visited.push i
      number = m[i[0]][i[1]]

      #to_left
      h = i[1] - 1
      while /\d/.match m[i[0]][h] and !visited.include?([i[0], h])
        number = m[i[0]][h] + number
        visited.push [i[0], h]
        h -= 1
      end

      #to_right
      h = i[1] + 1
      while /\d/.match m[i[0]][h] and !visited.include?([i[0], h])
        number += m[i[0]][h]
        visited.push [i[0], h]
        h += 1
      end
      res.push number.to_i
    end

    res
  end

  def run()
    input = parse_input(@original_text)
    solution1 = solve_part_1(input)
    puts "Solution1: #{solution1}"
    solution2 = solve_part_2(input)
    puts "Solution2: #{solution2}"
  end
end
