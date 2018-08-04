=begin
	This plugin allows editing of posts.
	You may only edit a post if you actually
	made the post.
=end

Command.new do
	name	"User edit"
	desc	"Allows users to edit their own posts."
	syntax	"+news edit <post path> <title>=<body>"
	help <<-eof
		This command will set the title and body of the post given by
		%|0|<post path>%|1| to %|1|<title>%|0| and %|1|<body>%|0| respectively, assuming that
		you made the post in the first place. Other users will be able
		to tell that you edited the post when reading it.
	eof

	match(/^edit (\d\/)*\d+ (.*?)=(.*)$/)

	trigger do |match|
		match[0] =~ /^edit ([0-9\/]+)/
		post = Util::get_post $1

		if post.nil?
			next NewsMessage.new{|n| n.message = "Post with that index not found."}
		elsif post.author != $CALLER
			next NewsMessage.new{|n| n.message = "You may only edit posts that you have made."}
		else	#We're on!
			post.title = match[-2]
			post.body = match[-1]
			post.num_times_edited += 1
			post.last_edited = Time.now
			$DIRTY << :news
			next NewsMessage.new{|n| n.message = "Your post has been edited."}
		end
	end
end
