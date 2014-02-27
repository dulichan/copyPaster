require 'fileutils'
require 'progressbar'
require 'workers'

module FileCopy
	def self.say(m)
		group = Workers::TaskGroup.new
		#FileUtils.copy_entry "from", "to"
		Dir.foreach("/Volumes/chan_drive/Development/scratch/from/") do |entry|		   
			in_name     = "/Volumes/chan_drive/Development/scratch/from/"+entry
			out_name    = "/Volumes/Battlestation/Development/scratch/to/"+entry
			if File.file?(in_name)
				in_file     = File.new(in_name, "r")
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
		group.run
	end
end