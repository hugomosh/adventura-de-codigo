class AOCDate
  attr_accessor :year, :day

  def initialize(day = nil, year = nil)
    ENV["TZ"] = "EST"
    today = Time.now
    @day = day
    @year = year
    @year_day = [@year, @day]
  end

  def request_input_url
    "https://adventofcode.com/%d/day/%d/input" % @year_day
  end

  def input_file_path
    "input/%d/day/%d.txt" % @year_day
  end

  def output_file_path
    "output/%d/day/%d.out" % @year_day
  end

  def class_path
    "%d/day%d.rb" % @year_day
  end

  def class_name
    "Puzzle%dday%d" % @year_day
  end
end
