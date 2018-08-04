=begin
	The util module contains various functions generally
	used by plugins.
=end

module Util

	def Util.string_to_postpath string
		return string.split('/').map{|n| n.to_i}
	end

	def Util.get_post path
		path = string_to_postpath path if path.kind_of? String
		path = [path] if path.kind_of? Integer
		return $DATA[:news].traverse(path)
	end

	def Util.make_coloured string, whose_colour, dbref=$CALLER
		if $DATA[:options].has_key? dbref and $DATA[:options][dbref][:color] == :off
			string
		else
			"[s(strcat(%|,get(#{whose_colour},color),|,{#{string}}))]"
		end
	end

	def Util.from_daemon string
		"get(#845,#{string})"
	end
end
