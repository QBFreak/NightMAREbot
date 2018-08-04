=begin
	In here we hold consants, lest
	they escape and ravage the
	countryside.
=end

require_relative 'news_message'

module Constants
	
	TITLE_BASE = <<EOF
%|9|+news help%|0|#{' ' * 6}#{Time.now.strftime("%Y-%m-%d %H:%M %Z").center(21)}#{"Version #{$VERSION}".rjust(16)}
%|4|-----%|12|-----%|6|-----%|14|---======= %|9|* %|14|=======---%|6|-----%|12|-----%|4|-----
EOF
	Constants::DIVIDER = <<EOF
%|4|-----%|12|-----%|6|-----%|14|-----------------------%|6|-----%|12|-----%|4|-----
EOF

	Constants::TITLE=TITLE_BASE.gsub(/\n/,'%r')
	
	#--Errmessages
	Constants::ERR_NOT_FOUND	= NewsMessage.new{|n| n.message = "Post not found."}
	Constants::ERR_NO_HELP		= NewsMessage.new{|n| n.message = "Help not found for that topic."}
	Constants::ERR_NOT_PERMITTED	= NewsMessage.new{|n| n.message = "You do not have permission to do that."}
	Constants::ERR_NO_COMMAND	= NewsMessage.new{|n| n.message = "Command not found. Check %|11|+news help commands%|0| for a list of commands."}

	#--Regex stuff
	Constants::PATH_TO_POST		= '(\d+\/)*\d+'
end

