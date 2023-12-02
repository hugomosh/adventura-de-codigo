class AOCDate
  def initialize(day = nil, year = nil)
    ENV["TZ"] = "EST"
    today = Time.now
    @day = day
    @year = year
  end

  def request_input_url
    "https://adventofcode.com/%d/day/%d/input" % [@year, @day]
  end

  def input_file_path
    "input/%d/day/%02d.txt" % [@year, @day]
  end

  def output_file_path
    "output/%d/day/%02d.out" % [@year, @day]
  end

  def class_path
    "%d/day%02d.rb" % [@year, @day]
  end
end
