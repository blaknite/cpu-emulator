#! /bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'computer'

file = ARGV.shift

unless file
  puts "Usage: run.rb <bin>"
  exit
end

Computer.debug = true
Computer.load_file(file)
Computer.run!
