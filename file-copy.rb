require 'fileutils'
require 'progressbar'
require 'workers'

module FileCopy
	def self.say(m)
		group = Workers::TaskGroup.new
		#FileUtils.copy_entry "from", "to"
		Dir.foreach("/Volumes/Battlestation/Ano_Hana") do |entry|		   
			in_name     = "/Volumes/Battlestation/Ano_Hana/"+entry
			out_name    = "/Volumes/chan_drive/Development/scratch/to/"+entry
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
	def self.rcopy(input, output)

	end
	def self.ncopy(input, output)
		if File.file?(input)
			in_file     = File.new(input, "r")
	    	out_file    = File.new(output, "w")
			p_bar       = ProgressBar.new('Copying file:-'+output, 100)
			in_size     = File.size(input)
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
	def self.copy(input, output, type)
		if type=='P'
			group = Workers::TaskGroup.new

			group.run
		else 
			Dir.foreach(input) do |entry|		   
				in_name     = input+entry
				out_name    = output+entry
				ncopy(in_name, out_name)
			end
		end
	end
end