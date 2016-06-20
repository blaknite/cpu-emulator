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
  f.write Assembler.assemble_program!(File.open(source_file, 'r').read).pack('C*')
end

puts File.open(target_file, 'r').read.unpack('C*').map{ |pd| '0x' + pd.to_s(16).rjust(2, "0") }.join(' ')
