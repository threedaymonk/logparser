require File.expand_path("../lib/logparser/version", __FILE__)

Gem::Specification.new do |s|
  # Change these as appropriate
  s.name              = "logparser"
  s.version           = LogParser::VERSION::STRING
  s.summary           = "Parse log files using a simple syntax."
  s.author            = "Paul Battley"
  s.email             = "pbattley@gmail.com"
  s.homepage          = "http://github.com/threedaymonk/logparser"

  s.has_rdoc          = false

  # Add any extra files to include in the gem (like your README)
  s.files             = %w(Rakefile) + Dir.glob("{test,lib}/**/*")

  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  # If your tests use any gems, include them here
  # s.add_development_dependency("mocha")
end

