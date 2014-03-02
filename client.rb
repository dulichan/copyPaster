$LOAD_PATH << '.'
require "file-copy"
require 'benchmark'

# puts Benchmark.measure { FileCopy.say "III" }
puts Benchmark.measure { FileCopy.copy("/Volumes/Battlestation/Ano_Hana/", "/Volumes/chan_drive/Development/scratch/to/", "P") }