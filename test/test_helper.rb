require 'tmf'
include TMF

if RUBY_VERSION < "1.9.2"
  puts "BasicQuest works best with ruby 1.9.3 (detected #{RUBY_VERSION})"
  puts "For older rubies, you will need to install the backports gem for BasicQuest to work."
  require 'rubygems'
  require 'backports'
end