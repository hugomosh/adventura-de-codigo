# frozen_string_literal: true

class AOCDate
  attr_accessor :year, :day

  def initialize(day = nil, year = nil)
    ENV['TZ'] = 'EST'
    today = Time.now
    @day = day
    @year = year
  end

  def request_input_url
    format('https://adventofcode.com/%<year>d/day/%<day>d/input', year: @year, day: @day)
  end

  def input_file_path
    format('input/%<year>d/day/%<day>d.txt', year: @year, day: @day)
  end

  def output_file_path
    format('output/%<year>d/day/%<day>d.out', year: @year, day: @day)
  end

  def class_path
    format('%<year>d/day%<day>d.rb', year: @year, day: @day)
  end

  def class_name
    format('Puzzle%<year>dday%<day>d', year: @year, day: @day)
  end
end
