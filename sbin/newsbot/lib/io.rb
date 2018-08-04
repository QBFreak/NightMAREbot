=begin
	Contains the IO module, which is only really
	a quick way to combine logging and putsing.
=end

module BotIO

	def BotIO.output_line message, file = nil
		puts message.encode
		file << "[#{Time.now.strftime("%Y-%m-%d @ %H:%M:%S")}] #{message}\n" unless file.nil?
	end
	
	def BotIO.output message_or_array
		f = File .open("data/log.txt", 'a')
		if message_or_array.kind_of? Array
			message_or_array.each do |line|
				self.output_line line, f
			end
		else
			self.output_line message_or_array, f
		end
		f.close
	end


	def BotIO.log_error err
		File.open("data/errlog.txt",'a') do |file|
			file << '-' * 20 << "\n\n"
			file << Time.now << "\n"
			file << "Caller: #$CALLER\n"
			file << "Error class: #{err.class}\n"
			file << "Error message: #{err.message}\n\n"
			file << "Error stack trace:\n"
			file << err.backtrace.join("\n") << "\n\n"
		end
	end
end
			

				
