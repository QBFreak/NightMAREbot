=begin
	This plugin allows you to read a news article,
	also marking it read.
=end

read = Command.new do
	name	"Read"
	desc	"Lets you read a news article"
	help <<-eof
		Using this command you can read news, which is kind of the purpose of having the
		newsboard here in the first place.
	eof
	syntax	"+news <postpath>"

	match(/^(\d+\/)*\d+$/)
	
	trigger do |match|
		post = Util::get_post match[0]
		next Constants::ERR_NOT_FOUND if post.nil?
		unless post.read_by?
			post.was_read_by $CALLER
			$DIRTY << :news
		end
		next NewsMessage.new{|n| n.message = post.display}
	end
end

