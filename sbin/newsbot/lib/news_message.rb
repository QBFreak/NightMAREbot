=begin
	This class simulates a returned message.
	The MARE handles it as:
	NEWS <dbref> <message>
	Which @pemits <message> to <dbref>
	
	It is sent to tinyfugue as
	<dbref> <message>
	Multiple lines are used for more than one @pemit
=end
require_relative 'options'

class NewsMessage
	
	attr_reader	:message
	attr_writer	:dbref

	def initialize
		yield self if block_given?
	end

	def dbref
		@dbref or $CALLER
	end

	def message= string
		@message = string.gsub(/([^%])%r/,'\1' + "\n")
	end

	def to_s
		@message.split("\n").inject('') do |string,line|
			string << "#{dbref} #{line}"
		end
	end

	def encode
		@message.gsub!(/%\|\d+\|/,'') if $DATA[:options][$CALLER][:color] == :off
		@message.split("\n").inject('') do |string, line|
			string << "#{Coder::encode(dbref)} #{Coder::encode(line)}\n"
		end
	end
end
