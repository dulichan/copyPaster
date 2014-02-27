require 'fileutils'
require 'progressbar'
require 'workers'
require 'benchmark'
module FileCopy
	def self.say(m)
		group = Workers::TaskGroup.new
		#FileUtils.copy_entry "from", "to"
		start_time = Time.now
		Dir.foreach("from") do |entry|		   
			in_name     = "from/"+entry
			out_name    = "to/"+entry

			in_file     = File.new(in_name, "r")
			if File.file?(in_name)
				group.add do
			    	out_file    = File.new(out_name, "w")
					p_bar       = ProgressBar.new('Copying file:-'+out_name, 100)
					in_size     = File.size(in_name)
					batch_bytes = ( in_size / 100 ).ceil
					total       = 0

					buffer      = in_file.sysread(batch_bytes)
					while total < in_size do
						out_file.syswrite(buffer)
						total += batch_bytes
						p_bar.inc
						if (in_size - total) < batch_bytes
					  		batch_bytes = (in_size - total)
						end
						buffer = in_file.sysread(batch_bytes)
					end
					p_bar.finish
			    end
			end
		end
		elapsed = Time.now - start_time
		puts Benchmark.measure { group.run }
		puts elapsed
	end
end