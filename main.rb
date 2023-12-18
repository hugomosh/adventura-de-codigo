# frozen_string_literal: true

require "net/http"
require "fileutils"
require_relative "date"
require "logger"
require "listen"

logger = Logger.new($stdout)

# Handles the interactions with adventofcode.com
class AdventOfCodeManager
  def self.download_input(date)
    input = "ERROR: No input!"
    puts "Reading %s" % date.input_file_path
    f = nil
    if !File.exist?(date.input_file_path)
      FileUtils.mkdir_p(File.dirname(date.input_file_path))
      input = request_day(date.request_input_url)
      puts "Creating %s" % date.input_file_path
      f = File.open(date.input_file_path, "w") { |file| file.write(input) }
    else
      puts "Input file exists!"
      f = File.open(date.input_file_path)
    end
    f.read
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

  def load_puzzle_class(date)
    create_puzzle_class(date) unless Object.const_defined?(date.class_name)
    require_relative date.class_path
  end

  def self.prepare_puzzle(date)
    input = download_input(date)
    load_puzzle_class(date)
    open_files(date)
    watch_for_changes(date, input)
  end
end

# Guia en la linea de comandos
class AdventurasDeCodigo
  ACTIONS = {
    1 => { name: "Start today's puzzle", description: "Do they puzzle for today." },
    2 => { name: "Wait for newest puzzle",
           description: "Is close to the release of the new puzzle and we want to get the input right away!" },
    3 => { name: "Solve a specific day", description: "Practicing or getting all the stars ⭐️." },
  }.freeze

  def initialize
    @logger = Logger.new($stdout)
  end

  def select_action
    puts "Adventura de código"
    puts "Qué acción quieres hacer:"
    puts ACTIONS.inspect
    ACTIONS.each do |key, value|
      puts "#{key}. #{value[:name]} - #{value[:description]}"
    end

    loop do
      choice = gets.chomp.to_i
      if ACTIONS.key?(choice)
        puts "Seleccionaste #{choice}."
        return choice
      else
        puts "Opción invalida."
      end
    end
  end

  def get_paramentes(choice)
    case choice
    when 1
    when 2
    when 3
      get_day_year
    end
  end

  def get_day_year
    input = nil
    current_year = Time.now.year
    puts "Give the day and year. Example 21 2023 or 21 23"
    loop do
      input = gets.chomp
      numbers = input.split.map(&:to_i)
      if numbers.length == 2 && numbers.first.between?(1,
                                                       25) && (numbers.last.between?(2015,
                                                                                     current_year) || numbers.last.between?(
        15, current_year % 100
      ))
        numbers[-1] = 2000 + numbers.last if numbers.last.between?(15, current_year % 100)
        return numbers
      else
        puts "1 20Invalid input. Please enter two integers between 1 and 25 separated by a space."
        puts "Your input was `#{input}` and we are expection 'day year'"
      end
    end
    numbers
  end

  def run
    loop do
      choice = select_action

      parameters = get_paramentes(choice)

      case choice
      when 1
      when 2
        wait_for_release
      when 3
        aoc_date = AOCDate.new(*parameters)
      end

      AdventOfCodeManager.prepare_puzzle(aoc_date) unless aoc_date.nil?
      print "Otra opción? (y/N):"
    end
  end

  def start_day(date); end

  def wait_for_release
    loop do
      sleep
    end
  end
end

def read_env
  puts "Reading .env file for the adventofcode.com session"
  envFile = File.open(".env")
  content = envFile.readlines.map(&:chomp)
  env = {}
  content.each do |line|
    v = line.split("=")
    env[v.first] = v.last
  end
  envFile.close
  env
end

def info
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

def prepare_puzzle(date)
  input = download_input(date)
  load_puzzle_class(date)
  open_files(date)
  watch_for_changes(date, input)
end

def load_puzzle_class(date)
  create_puzzle_class(date) unless Object.const_defined?(date.class_name)
  require_relative date.class_path
end

def open_files(date)
  system("gp open #{date.input_file_path} #{date.class_path}")
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
  listener = Listen.to(File.dirname(date.input_file_path),
                       File.dirname(date.class_path)) do |modified, _added, _removed|
    puts "File updated! Rerunning your code...", modified.inspect
    if modified.any? { |str| str.include?(".txt") }
      puts "input changed"
      input = download_input(date)
    end
    begin
      begin
        eval(File.read(date.class_path), TOPLEVEL_BINDING, date.class_path)
      rescue SyntaxError => e
        puts "Syntax error in loaded file: #{e.message}"
        puts "Backtrace:\n#{e.backtrace.join("\n")}"
        next # Skip the rest of the loop and wait for the next file change
      end
      aoc = Object.const_get(date.class_name).new(input)
      aoc.run
    rescue StandardError => e
      puts "An unexpected error occurred: #{e.message.slice(0, 100)}"
      puts "Backtrace:\n#{e.backtrace.join("\n")}"
    end
  end
  puts "Que comience la adventura!"
  puts "Watching for changes on #{File.dirname(date.input_file_path)}/ and #{File.dirname(date.class_path)}/. Press Ctrl+C to stop."

  Signal.trap("INT") do
    puts "\nAdventura terminada! "
    # system("gp open main.rb")
    exit
  end
  listener.start
  sleep
rescue StandardError => e
  puts "Error in loaded script: #{e.message}"
end

def run_day(date, input)
  aoc = Object.const_get(date.class_name).new(input)
  aoc.run
end

$env = read_env

def main
  puts $env
  puts $env.has_key? "session"

  info
  year = 2023
  day = 11
  aoc_date = AOCDate.new(day, year)

  prepare_puzzle(aoc_date)
end

main

# adventura = AdventurasDeCodigo.new()
# adventura.run()
