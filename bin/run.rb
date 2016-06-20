#! /bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'computer'

bin = ARGV.shift

unless bin
  puts "Usage: run.rb <bin>"
  exit
end

c = Computer.new
c.load_program(File.open(bin, 'r').read.unpack('C*'))
c.run!
