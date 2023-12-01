class AOCDate
  def initialize(day = nil, year = nil)
    ENV["TZ"] = "EST"
    puts ENV["TZ"]
    today = Time.now
    puts today
    @day = day
    @year = year
  end

  def request_input_url
    "https://adventofcode.com/%d/day/%d/input" % [@year, @day]
  end

  def file_path
    "input/%d/day/%02d.txt" % [@year, @day]
  end
end
