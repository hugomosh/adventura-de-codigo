require "net/http"
require "fileutils"
require_relative "date"
require_relative "2023/day01.rb"

puts "Adventura de código"

def read_env()
  puts "Reading .env file for the adventofcode.com session"
  envFile = File.open(".env")
  content = envFile.readlines.map(&:chomp)
  env = {}
  content.each { |line|
    v = line.split("=")
    env[v.first] = v.last
  }
  envFile.close
  env
end

def info()
  puts "Today is " + Time.now.strftime("%F %T")
  puts "Ruby version:".ljust(30) + RUBY_VERSION.rjust(10)
  puts "Has .env with session: ".ljust(30) + $env.has_key?("session").to_s.rjust(10)
end

def request_day(url)
  puts "Requesting"
  puts url
  res = Net::HTTP.get_response(URI(url), {
    "COOKIE" => "session=" + $env["session"],
    "USER_AGENT" => "HUGO_ADVENTURA",
  })
  res.body
end

def is_digit?(s)
  code = s.ord
  "0".ord <= code && code <= "9".ord
end

$text_digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

def to_value(text)
  if is_digit? text
    return text.to_i
  elsif $text_digits.include?(text)
    return $text_digits.index(text) + 1
  else
    puts text
    throw "BAD INPUT "
  end
end

def main()
  $env = read_env()
  puts $env
  puts $env.has_key? "session"

  info()
  year = 2023
  day = 1
  aoc_date = AOCDate.new(day, year)

  input = "ERROR: No input!"
  puts "R eading %s" % aoc_date.file_path

  if !File.exist?(aoc_date.file_path)
    FileUtils.mkdir_p(File.dirname(aoc_date.file_path))
    input = request_day(aoc_date.request_input_url)
    puts "Creating %s" % aoc_date.file_path
    File.open(aoc_date.file_path, "w") { |file| file.write(input) }
    puts f
  else
    puts "Input file exists!"
    f = File.open(aoc_date.file_path)
    input = f.read
  end
  puts input.lines.take(10)
  puts "..."

  aoc = Aoc2023d01.new()

  aoc.run()

  sum = 0

  input.lines.each do |line|
    i = 0
    j = line.size - 1
    while !is_digit?(line[i])
      i += 1
    end
    while !is_digit?(line[j])
      j -= 1
    end
    number = line[i] + line[j]
    sum += number.to_i
  end
  puts sum

  sum = 0

  input.lines.each do |line|
    scan = line.scan(/[0-9]/)
    number = to_value(scan.first).to_s + to_value(scan.last).to_s
    # puts "L: " + line
    # puts scan.to_s
    # puts number
    sum += number.to_i
  end
  puts sum

  #part 2
  puts "Part 2"
  sum = 0

  # one|two|three|four|five|six|seven|eight|nine
  input.lines.each do |line|
    scan = line.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|[0-9]))/).flatten
    number = to_value(scan.first).to_s + to_value(scan.last).to_s
    # puts "L: " + line
    # puts scan.to_s
    # puts number
    sum += number.to_i
  end
  puts sum

  # not 56322
end

main()
