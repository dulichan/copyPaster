require 'fileutils'
require 'progressbar'
require 'workers'
require 'rsync'

module FileCopy
	#flag to switch logs
	LOG_FLAG=false
	'''
		Performs copy operation based on rsync library. This will work in OS X and Linux.
	'''
	def self.rcopy(input, output)
		if LOG_FLAG
			p_bar = ProgressBar.new('Copying file:-'+output, 100)
		end
		Rsync.run(input.inspect, output.dump) do |result|
	      if result.success?
	        result.changes.each do |change|
	        	if LOG_FLAG
					p_bar.inc
				end
	        end
	      else
	        puts result.error
	      end
	    end
	    if LOG_FLAG
	    	p_bar.finish
	    end
	end
	'''
		Performs copy operation based on basic copying library
	'''
	def self.ncopy(input, output)
		in_file     = File.new(input, "r")
    	out_file    = File.new(output, "w")
    	if LOG_FLAG
    		p_bar   = ProgressBar.new('Copying file:-'+output, 100)
    	end

		in_size     = File.size(input)
		batch_bytes = ( in_size / 100 ).ceil
		total       = 0
		buffer      = in_file.sysread(batch_bytes)
		while total < in_size do
			out_file.syswrite(buffer)
			total += batch_bytes
			if LOG_FLAG
				p_bar.inc
			end
			if (in_size - total) < batch_bytes
		  		batch_bytes = (in_size - total)
			end
			buffer = in_file.sysread(batch_bytes)
		end
		if LOG_FLAG
			p_bar.finish
		end
	end
	'''
		Responsible for determining whether to perform rsync or cp
	'''
	def self.transformCopy(input, output, method)
		if method=="normal"
			ncopy(input, output);
		elsif method=="rsync"
			rcopy(input, output);
		end
	end

	'''
		Exposed API that performs copying
	'''
	def self.copy(input, output, type="N", method="normal")
		if type=='P'
			group = Workers::TaskGroup.new
			Dir.foreach(input) do |entry|
				in_name     = input+entry
				out_name    = output+entry
				if File.file?(in_name)
					group.add do
						transformCopy(in_name, out_name, method)
					end
				end
			end
			group.run
		else
			Dir.foreach(input) do |entry|
				in_name     = input+entry
				out_name    = output+entry
				if File.file?(in_name)
					transformCopy(in_name, out_name, method)
				end
			end
		end
	end
end
