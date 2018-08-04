=begin
	The Command class is subclassed to allow
	for plugin commands.
=end

require 'lib/help'

class Command < HelpTopic
	
	@commands = []
	
	class << self
		attr_accessor	:commands
		
		#Loads all commands from file
		def load
			Dir["plugins/*.rb"].each do |f|
				require f
			end
		end
		
		#Allows us to traverse and run plugins
		def filter_all string
			@commands.each do |rc|
				if (m = rc.match.match string)
					return rc.trigger.call(m)
				end
			end
			return Constants::ERR_NO_COMMAND
		end
		
		#Shows all plugins and descriptions
		def quick_help
			@commands.inject(''){|sum, obj| sum + obj.to_s + '%r'}
		end
	end
	
	#Syntactical-sugary fields
	[:syntax, :match].each do |val|
		define_method(val) do |*args|
			case args.size
			when 0:	instance_variable_get("@#{val}")
			else	instance_variable_set("@#{val}",args[0])
			end
		end
	end

	#Trickier as it takes a block
	def trigger &block
		if block
			@trigger = block
		else
			@trigger
		end
	end

	def to_s type=:short
		if type == :short
			name + ': ' + desc
		else
			'%|9|' + name + ': %|11|' + syntax.gsub(/<(.*?)>/,'%|12|<\1>%|11|') + '%r' + help
		end
	end
		

	def initialize &block
		super &block
		
		Command.commands << self
	end
end
