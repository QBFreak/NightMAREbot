=begin
	The nofitication class allows
	for notifications and messages.
=end

class Notify
	attr_accessor	:deviations,	:default
	
	#Standard init
	def initialize default
		@default = default
		@deviations = {}
		#TODO: Errorcheck?
	end

	#Returns the level of the specified dbref
	def level dbref=$CALLER
		deviations[dbref] or default
	end

	#Alternative notation
	alias_method :[], :level

	#Changes the user's level to something else
	def change_level new_level, dbref=$CALLER
		if new_level == default
			deviations.delete dbref
		else
			deviations[dbref] = new_level
		end
	end

	#Alternative notation, no defaults allowed
	def []= dbref, new_level
		change_level new_level, dbref
	end

	#Filters out a certain subset of given notifies:
	def filter &blck
		@deviations.delete_if{|k,v| blck.call(k,v)}
	end
end
