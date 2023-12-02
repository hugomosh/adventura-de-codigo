require "net/http"
require "fileutils"
require_relative "date"
require "logger"
logger = Logger.new(STDOUT)

class AdventurasDeCodigo
  def initialize
    @logger = Logger.new(STDOUT)
  end
end

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
  input = download_input(date)
  load_puzzle_class(date)
  watch_for_changes(date, input)
end

def load_puzzle_class(date)
  unless Object.const_defined?(date.class_name)
    create_puzzle_class(date)
  end
  require_relative date.class_path
end

def create_puzzle_class(date)
  if File.exist?(date.class_path)
    puts "File for class #{date.class_path} already exists."
    return
  end

  template = File.read("template/puzzle_template.rb")
  content = template.gsub("{year}", date.year.to_s).gsub("{day}", date.day.to_s)
  FileUtils.mkdir_p(File.dirname(date.class_path))
  File.write(date.class_path, content)
  puts "Created file: #{date.class_path}"
end

def download_input(date)
  input = "ERROR: No input!"
  puts "Reading %s" % date.input_file_path

  if !File.exist?(date.input_file_path)
    FileUtils.mkdir_p(File.dirname(date.input_file_path))
    input = request_day(date.request_input_url)
    puts "Creating %s" % date.input_file_path
    f = File.open(date.input_file_path, "w") { |file| file.write(input) }
  else
    puts "Input file exists!"
    f = File.open(date.input_file_path)
    input = f.read
  end

  input
end

def watch_for_changes(date, input)
  puts "Sorry, can't watch for changes yet!"
  puts "But I can run the code fior #{date.class_name} once"

  aoc = Object.const_get(date.class_name).new(input)
  aoc.run()
end

def main()
  $env = read_env()
  puts $env
  puts $env.has_key? "session"

  info()
  year = 2019
  day = 1
  aoc_date = AOCDate.new(day, year)

  prepare_puzzle(aoc_date)
end

main()

adventura = AdventurasDeCodigo.new()
