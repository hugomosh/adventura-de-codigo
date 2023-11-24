puts "Adventura de código"

def readEnv()
  puts "Reading .env file for the adventofcode.com session"
  envFile = File.open(".env")
  content = envFile.read
  envFile.close
  puts content
end

def info()
  puts "Ruby version #{RUBY_VERSION}"
end

def main()
  info()

  readEnv()
end

main()
