require "net/http"
require "fileutils"
require_relative "date"
require_relative "2023/day01.rb"
require_relative "2023/day02.rb"

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
  return res.body
end

def prepare_puzzle(date)
  template = File.read("templae/puzzle_tempalte.rb")
  content = template.gsbug("{year}", year.to_s).gsub("{day}", day.to_s)

  File.write(date.class_path, content)
end

def main()
  $env = read_env()
  puts $env
  puts $env.has_key? "session"

  info()
  year = 2023
  day = 2
  aoc_date = AOCDate.new(day, year)

  input = "ERROR: No input!"
  puts "Reading %s" % aoc_date.input_file_path

  if !File.exist?(aoc_date.input_file_path)
    FileUtils.mkdir_p(File.dirname(aoc_date.input_file_path))
    input = request_day(aoc_date.request_input_url)
    puts "Creating %s" % aoc_date.input_file_path
    File.open(aoc_date.input_file_path, "w") { |file| file.write(input) }
    puts f
  else
    puts "Input file exists!"
    f = File.open(aoc_date.input_file_path)
    input = f.read
  end
  puts input.lines.take(10)
  puts "..."

  aoc = Puzzle2023day02.new(input)

  aoc.run()
end

main()
