#! /bin/ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'assembler'

source_file = ARGV.shift
target_file = ARGV.shift

unless source_file && target_file
  puts "Usage: assemble.rb <source> <target>"
  exit
end

File.open(target_file, 'w') do |f|
  f.puts Assembler.assemble_program!(File.open(source_file, 'r').read)
end

puts File.open(target_file, 'r').read
