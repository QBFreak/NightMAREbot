=begin
	Decodes a string from parsed form to normal form
=end

module Coder

	def Coder.decode string
		string.gsub(/_(\d+)_/) {|s| $1.to_i.chr}
	end

	def Coder.encode string
		string.gsub(/[^0-9A-Za-z]/) {|s| "_#{s[0]}_"}
	end
end
