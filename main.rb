require "net/http"
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
  puts "Ruby version:".ljust(30) + RUBY_VERSION.rjust(10)
  puts "Has .env with session: ".ljust(30) + $env.has_key?("session").to_s.rjust(10)
end

def request_day(year, day)
  v = [day, year]
  puts "Requesting day %02d %04d" % v
  url = "https://adventofcode.com/%d/day/%d/input" % v.reverse
  puts url

  res = Net::HTTP.get_response(URI(url), {
    "COOKIE" => "session=" + $env["session"],
    "USER_AGENT" => "HUGO_ADVENTURA",
  })
  puts res.body
end

def main()
  $env = read_env()
  puts $env
  puts $env.has_key? "session"

  info()
  year = 2015
  day = 1
  request_day(year, day)
end

main()
