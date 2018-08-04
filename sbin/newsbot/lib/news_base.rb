=begin
	This class provides a base for the news tree.
	It contains many methods that news_item does
	and basically tidies stuff up nicely.
=end

require_relative 'news_parent'

class NewsBase < NewsParent
	
	#In place of method from NewsParent
	def parent
		$DATA[:news]
	end
end
