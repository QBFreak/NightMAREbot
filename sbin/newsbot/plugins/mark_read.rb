=begin
	Two methods, which allows various bits
	of the news board to be marked read.
=end

Command.new do
	name	"Mark read"
	desc	"Marks news items read"
	help <<-eof
	This allows you to set all news items read at once, rather than have to read
	each individually. If you supply no post path, it will mark all posts read -
	otherwise, it will just mark that post and all replies read.
	eof
	syntax	"+news read [post path]"
	
	match(/^read( #{Constants::PATH_TO_POST})?/)

	trigger do |match|
		if match[0] =~ /^read$/
			$DATA[:news].each_child{|n| n.mark_all_read}
			$DIRTY << :news
			next NewsMessage.new{|n| n.message = "All news articles marked read."}
		else
			match[0] =~ /^read ([0-9\/]+)/
			post = Util::get_post $1

			next(Constants::ERR_NO_POST) if post.nil?
			
			post.mark_all_read
			$DIRTY << :news
			next NewsMessage.new{|n| n.message = "News articles marked read."}
		end
	end
end
	

