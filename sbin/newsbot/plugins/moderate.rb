=begin
	Contains the moderator commands. Moderator commands may only be executed by people in the
	$DATA[:moderators] group. All moderator commands take the form +news mod <command>.

	NOTE: Since I can't check whether or not a dbref is a player, anything can become a mod.
=end

#Lists all mods
Command.new do
	name	"Mod List"
	desc	"Lists all newsboard moderators"
	help <<-eof
		This command lists all moderators for the newsboard system. Unlike most
		moderator commands, anyone may use this.
	eof
	syntax	"+news mod list"

	match(/^mod list$/)

	trigger do
		next NewsMessage.new{|n| n.message = "Current moderators are: " + $DATA[:moderators].map{|v| "[name(#{v})]"}.join(', ')}
	end
end

#Promotes a dbref to mod
Command.new do
	name	"Mod Add"
	desc	"Promotes a user to newsboard moderator status"
	help <<-eof
		This command makes a user a newsboard moderator. Only dbrefs may be used in this
		way - names will not work and will not be recognised. Only current mods may
		promote other users to mod status.
	eof
	syntax	"+news mod add <dbref>"

	match(/^mod add (#\d+)$/)

	trigger do |match|
	next Constants::ERR_NO_PERMISSION unless $DATA[:moderators].include? $CALLER
	next  NewsMessage.new{|n| n.message = "[name(#{match[1]})] is already a moderator."} if $DATA[:moderators].include? match[1]
	
	$DATA[:moderators] << match[1]
	$DIRTY << :moderators
	next [
		NewsMessage.new{|n| n.message = "[name(#{match[1]})] promoted to moderator status."},
		NewsMessage.new do |n|
			n.dbref = match[1]
			n.message = "[name(#$CALLER)] just promoted you to moderator status on the newsboard."
		end
	]
	end
end

#Demotes a dbref from mod
Command.new do
	name	"Mod Remove"
	desc	"Demotes a newsboard moderator"
	help <<-eof
		This command demotes a newsboard moderator. Only dbrefs may be used in this way
		- name will not work and will not be recognised. Only current mods may demote
		others.
	eof
	syntax	"+news mod remove <dbref>"

	match(/^mod remove (#\d+)$/)

	trigger do |match|
		next Constants::ERR_NO_PERMISSION unless $DATA[:moderators].include? $CALLER or match[1] =~ /^#(5|2484)$/
		next NewsMessage.new{|n| n.message = "[name(#{match[1]})] isn't a moderator anyway."} unless $DATA[:moderators].include? match[1]
		
		$DATA[:moderators].delete match[1]
		$DIRTY << :moderators
		next [
			NewsMessage.new{|n| n.message = "[name(#{match[1]})] demoted from moderator status."},
			NewsMessage.new do |n|
				n.dbref = match[1]
				n.message = "[name(#$CALLER)] just demoted you from moderator status on the newsboard."
			end
		]
	end
end

#Deletes a post. Oh Em Gee.
Command.new do
	name	"Mod Delete"
	desc	"Deletes a post"
	help <<-eof
		This command deletes a post. If the post has no replies, it will be actually
		deleted from the database. If it has replies, the title and body will change to
		show that it has been deleted, but the post itself will not be deleted. Only
		moderators may delete posts by this method - for users, check "User delete".
	eof
	syntax	"+news mod delete <post path>"

	match(/^mod delete #{Constants::PATH_TO_POST}$/)
	
	trigger do |match|
		next Constants::ERR_NOT_PERMITTED unless $DATA[:moderators].include? $CALLER

		match[0] =~ /^mod delete ([0-9\/]+)$/
		post = Util::get_post $1
		next Constants::ERR_NOT_FOUND if post.nil?
		post.parent.delete post
		next NewsMessage.new{|n| n.message = "Post deleted."}
	end
end

#Edits any post.
Command.new do
	name	"Mod Edit"
	desc	"Edits a post"
	help <<-eof
		This command edits a post. The post's title will be changed to %|1|<title>%|0| and the
		body to %|1|<body>%|0|. Only moderators may delete posts by this method - for users,
		check "User edit".
	eof
	syntax	"+news mod edit <post path> <title>=<body>"

	match(/^mod edit #{Constants::PATH_TO_POST} (.*?)=(.*)$/)
	
	trigger do |match|
		next Constants::ERR_NOT_PERMITTED unless $DATA[:moderators].include? $CALLER

		match[0] =~ /mod edit ([0-9\/]+)/
		post = Util::get_post $1
		next Constants::ERR_NOT_FOUND if post.nil?

		post.title = match[-2]
		post.body = match[-1]
		$DIRTY << :news
		next NewsMessage.new{|n| n.message = "Post edited."}
	end
end

#Stickifies a post
Command.new do
	name	"Mod Sticky"
	desc	"Allows a mod to sticky a post"
	help <<-eof
		This command allows mods to make posts "sticky". Sticky posts appear at the top
		of the NewsBoard no matter what, and thus it is a good place to put notices of
		MARE activity or intro posts. By adding %|11|on%|0| or %|11|off%|0| after the dbref mods can
		specify whether they are stickying or unstickying a post - by default the post
		is stickied.
	eof
	syntax	"+news sticky <dbref> [on|off]"

	match(/^mod sticky (\d+)(?: (on|off))?/)

	trigger do |match|
		next Constants::ERR_NOT_PERMITTED unless $DATA[:moderators].include? $CALLER
		turn_on = (match[2].nil? ? true : (match[2] == 'on'))
		next(Constants:ERR_NOT_FOUND) if (match[1].to_i > $DATA[:news].size)
		post = $DATA[:news][match[1].to_i - 1]
		next NewsMessage.new{|n| n.message = "This already appears to be the state of affairs."} if (turn_on == post.sticky)
		if turn_on
			post.sticky = true
			next NewsMessage.new{|n| n.message="Post \"#{post.title}\" has been stickied."}
		else
			post.sticky = false
			next NewsMessage.new{|n| n.message="Post \"#{post.title}\" has been unstickied."}
		end
	end
end
