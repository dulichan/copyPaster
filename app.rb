$LOAD_PATH << '.'
require "file-copy"
Shoes.app do
	def answer(v)
		v = FileCopy.say(v)
		@answer.replace v.inspect
  	end	
	@list  = stack do
		button "Copy" do 
			answer "BBBB"
		end
	end
	Shoes.show_log
	@answer = para "Answers appear here"
end