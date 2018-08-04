=begin
	Contains code for posting and replying to news.
=end

require 'lib/util'

Command.new do

	name	"Post"
	desc	"Makes a new post to the newsboard"
	help <<-eof
		Using this command you may make your own post to the newsboard. The post will be
		added to the end of the board, and will have title of %|1|<title>%|0| and content of
		%|1|<body>%|0|. Special characters such as %%r and %%t are allowed, as are colours.
		However the following characters are not allowed in your post: < > | [chr(59)].
	eof
	syntax	"+news post <title>=<body>"

	match(/^post (.*?)=(.*)/)
	
	trigger do |match|
		post = NewsItem.new do |p|
			p.title = match[1]
			p.body = match[2]
			p.author = $CALLER
			p.index = [$DATA[:news].size + 1]
		end
		$DATA[:news] << post
		$DIRTY << :news
		return_arr = []
		return_arr << NewsMessage.new{|n| n.message = "Your post, \"#{post.title}\", has been made at index #{post.index[0]}!"}
		$DATA[:options].select{|k,v| [:posts, :all].include? v[:message] and not k == $CALLER}.each do |k,x|
			return_arr << NewsMessage.new do |n|
				n.dbref		= k
				n.message	= "%|15|Newsboard Message:%|0| A new post has been made by " + Util::make_coloured("[name(#$CALLER)]",$CALLER,k) + '.'
			end
		end
		next return_arr
	end
end


Command.new do
	
	name	"Reply"
	desc	"Replies to an existing post"
	help <<-eof
		Using this command you may reply to a post or reply on the newsboard. The reply
		will be made to the post given by %|1|<post path>%|0|, with title of %|1|<title>%|0| and content
		of %|1|<body>%|0|. Similar restrictions on content apply as with news posts - check help
		on "make news post" for more info.
	eof
	syntax	"+news reply <post path> <title>=<body>"

	match(/^reply (\d\/)*\d+ (.*?)=(.*)/)
	
	trigger do |match|
		match[0] =~ /^reply ([0-9\/]+)/
		post = Util::get_post $1

		if post.nil?
			next NewsMessage.new{|n| n.message = "No post found for this number."}
		elsif post.locked
			next NewsMessage.new{|n| n.message = "This post has been locked. You cannot reply to it."}
		else
			reply = NewsItem.new do |p|
				p.title = match[-2]
				p.body = match[-1]
				p.author = $CALLER
				p.index = post.index + [post.children.size + 1]
			end
			post.replies << reply
			$DIRTY << :news
			return_arr = []
			return_arr << NewsMessage.new{|n| n.message = "You have replied to post #$1 with your post, \"#{reply.title}\"."}
			$DATA[:options].select{|k,v| v == :all and not  k == $CALLER}.each do |k,x|
				return_arr << NewsMessage.new do |n|
					n.dbref = k
					n.message =	"%|15|Newsboard Message: " +
							Util::make_coloured("[name(#$CALLER)]",$CALLER,k) +
							" has posted a reply to post %|15|#$1%|0|."
				end
			end
			next return_arr
		end
	end
end
