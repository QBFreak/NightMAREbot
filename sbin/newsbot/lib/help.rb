=begin
	The HelpTopic class is designed for anything that
	can be shown in help.
=end

class HelpTopic
	#You pass the HelpTopic a block on init, which then executes
	#said help block.
	def initialize &block
		instance_eval(&block)
		
		HelpTopic.add_help self
	end
	
	#Make some shiny fields
	[:name, :desc, :help].each do |name|
		define_method(name) do |*args|
			case args.size
			when 0:	instance_variable_get("@#{name}")
			else	instance_variable_set("@#{name}",args[0].gsub(/^\s+/,''))
			end
		end
	end
	
	#Display as string
	def to_s length=:short
		if length == :short
			"%|1|#{name}%|0|: #{desc}"
		else
			"%|9|#{name}%|0|\n#{help}"
		end
	end

	#Stuff to deal with the list of topics
	@help_topics = {}
	class << self
		attr_accessor	:help_topics

		def load
			Dir["help/*.rb"].each do |f|
				require f
			end
		end

		def add_help topic
			raise ArgumentError, "Argument must be of type HelpTopic" unless topic.kind_of? HelpTopic
			raise RuntimeError, "Key #{topic.name} found in help multiple times." if @help_topics.has_key? topic.name.downcase
			@help_topics[topic.name.downcase] = topic
		end

		def find search_string
			return [@help_topics[search_string.downcase]] if @help_topics.has_key? search_string.downcase
			@help_topics.select{|k,v| k =~ /#{search_string}/i}.map{|arr| arr[1]}
		end
	end
end

#This command allows you to add code to be eval'ed when help is called.
#Would use a proc, but won't Marshal.dump
class InteractiveHelpTopic < HelpTopic
	def to_s length=:short
		if length == :short
			"%|1|#{name}%|0|: #{desc}"
		else
			"%|1|#{name}%|0|\n#{eval help}"
		end
	end
end
