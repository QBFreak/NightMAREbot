=begin
	These plugins deal with monitoring status
	as well as changing notification levels.
=end

Command.new do
	name	"Status"
	desc	"Shows basic status"
	help <<-eof
		This command shows you your basic status, including your notification and
		message levels.
	eof
	syntax	"+news status"

	match(/^status/)
	trigger do
		unr_replies = $DATA[:news].children.inject(0){|sum, n| sum + n.num_unread_replies(false)}
		unr_posts = $DATA[:news].children.inject(0){|sum,n| n.read_by? ? sum : sum + 1}
		
		not_sym =	$DATA[:options][$CALLER][:notify]
		msg_sym =	$DATA[:options][$CALLER][:message]
		notify = case not_sym
			when :none	: 'nothing'
			when :posts	: 'posts only'
			when :all	: 'everything'
		end
		messages = case msg_sym
			when :none	: 'nothing'
			when :posts	: 'posts only'
			when :all	: 'everything'
		end
		next NewsMessage.new do |n|
			n.message = [
				"You have %|11|#{unr_posts}%|0| unread post#{unr_posts == 1 ? '' : 's'}.",
				"You have %|11|#{unr_replies}%|0| unread repl#{unr_replies==1 ? 'y' : 'ies'}.",
				"You are being notified of %|11|#{notify}%|0|.",
				"You are being messaged on %|11|#{messages}%|0|."
			].join('%r')
		end
	end
end
