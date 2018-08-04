=begin
	Reading posts, showing recent posts,
	post paths.
=end

HelpTopic.new do
	name	"Basics: Reading posts"
	desc	"How to see recent posts and read them"
	help <<-eof
		To see the most recent posts (including "stickies", or important posts), just
		type:
		%|11|+news
		Unread news items will have a [NEW] before them, and unread replies are marked
		at the end of the title in parentheses. If a post has any unread content
		(counting the post itself and replies) the index number will be highlighted. To
		read a particular post, type:
		%|11|+news %|12|<post number>
		This will show the news article, as well as any replies and other notes about
		the post. If you wish to read replies, type a post path instead of a post
		number. For information on post paths, type %|11|+news help post path%|0|.
		For more ways to view posts, check the help on %|11|history%|0| and %|11|show full%|0|.
	eof
end

HelpTopic.new do
	name	"Basics: Post paths"
	desc	"What they are and how to use them"
	help <<-eof
		Post paths are simply a way of indicating the path to a post. They are a series
		of numbers separated by slashes. For example, the post path to the 3rd reply
		to post 5 would be %|11|5/3%|0|, while the path to the 1st reply to that reply
		would be %|11|5/3/1%|0|. If you wanted to read this post, you would type:
		%|11|+news 5/3/1
	eof
end

HelpTopic.new do
	name	"Basics: Posting"
	desc	"How to post and reply to posts"
	help <<-eof
		To post something to the newsboard, simply type:
		%|11|+news post %|12|<title>%|11|=%|12|<body>
		This will create a news post with title of %|12|title%|0| and content of
		%|12|body%|0|.
		To reply to an existing post, type:
		%|11|+news reply %|12|<post path> <title>%|11|=%|12|<body>
		For more information on post paths, type %|11|+news help post path%|0|.
		The other options are the same as for posting.
	eof
end

HelpTopic.new do
	name	"Basics: Editing and deleting"
	desc	"How to edit and delete your posts."
	help <<-eof
		To edit your post, type:
		%|11|+news edit %|12|<post path> <title>%|11|=%|12|<body>
		As of right now there is no way to find and replace in a post (for
		correcting typos and the like), but it is planned. The title and body
		of the post will be replaced by the supplied %|12|title%|0| and %|12|body%|0|.
		The post will be marked as edited, so don't go getting ideas about screwing
		with people's minds by changing your post content.
		To delete your post, type:
		%|11|+news delete %|12|<post path>
		This will delete the post. If more posts have been made (or the post has
		replies), the title and content will be erased and the post will be locked
		against further replies. Otherwise, the post (or reply) is well and truly
		deleted.
		For more information on post paths, type %|11|+news help post path%|0|.
	eof
end
