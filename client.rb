$LOAD_PATH << '.'
require "file-copy"
require 'benchmark'

# puts Benchmark.measure { FileCopy.say "III" }
result1 = Benchmark.measure { FileCopy.copy("/Volumes/Battlestation/Ano_Hana/", "/Volumes/chan_drive/Development/scratch/to/", "P", "rsync") }
puts "Rsync copying -Parallel run :-#{result1.real}"

result1 = Benchmark.measure { FileCopy.copy("/Volumes/Battlestation/Ano_Hana/", "/Volumes/chan_drive/Development/scratch/to/", "N", "rsync") }
puts "Rsync copying -Normal run :-#{result1.real}"

result1 = Benchmark.measure { FileCopy.copy("/Volumes/Battlestation/Ano_Hana/", "/Volumes/chan_drive/Development/scratch/to/", "P", "normal") }
puts "Normal copying -Parallel run :-#{result1.real}"

result1 = Benchmark.measure { FileCopy.copy("/Volumes/Battlestation/Ano_Hana/", "/Volumes/chan_drive/Development/scratch/to/", "N", "rsync") }
puts "Normal copying -normal run :-#{result1.real}"