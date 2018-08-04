=begin
	The options class stores a bunch of options.
	It's extremely flexible, allowing for any number
	of options including defaults.
=end

class Option
	@defaults = {
		:notify		=> :posts,
		:message	=> :none,
		:color		=> :on
	}

	@allowed = {
		:notify		=> [:all, :posts, :none],
		:message	=> [:all, :posts, :none],
		:color		=> [:on, :off]
	}

	attr_accessor	:options
	
	def initialize
		@options = {}
	end
	
	def [] option
		return (@options[option] or Option.defaults[option] or raise ArgumentError, "Value #{option} not set")
	end

	def []= option, value
		raise ArgumentError, "Value #{value} is not allowed for #{option}." if Option.allowed.has_key? option and (not  Option.allowed[option].include? value)	
		@options[option] = value
		$DIRTY << :options
	end

	def to_s
		[
			@options.map{|k,v| "%|11|#{k}:%|0| #{v}"},
			Option.defaults.select{|k,v| not @options.has_key? k}.map{|arr| "%|11|#{arr[0]}:%|0| #{arr[1]}"}
		].flatten.join("\n")
	end

	class << self
		attr_accessor	:defaults, :allowed
	end
end

#The OptionHash allows creation of a new Option every time a null value is called.
#Normal hashes cannot be serialised if they contain procs.
class OptionHash < Hash
	
	def [] key
		unless has_key? key
			self[key] = Option.new
			$DIRTY << :options
		end
		fetch(key)
	end
end
