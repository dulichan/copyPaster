$LOAD_PATH << '.'
require "file-copy"
require 'benchmark'

puts Benchmark.measure { FileCopy.say "III" }