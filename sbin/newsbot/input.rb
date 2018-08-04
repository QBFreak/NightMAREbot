require 'lib/coder'

while (a = gets)
	puts Coder::decode(`ruby newsboard.rb #5 #{Coder::encode(a)}`)
end
