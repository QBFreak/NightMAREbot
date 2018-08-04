=begin
	This module now contains all aconnect stuff
=end


module OnConnect
	def OnConnect.run dbref=$CALLER
		look_for =	if $DATA[:options].has_key? $CALLER
					$DATA[:options][$CALLER][:notify]
				else
					Option::defaults[:notify]
				end
		num_unread = 	case look_for
				when :all: $DATA[:news].children.inject(0){|sum, n| sum + n.num_unread_replies(true, dbref)}
				when :posts: $DATA[:news].children.select{|p| not p.read_by? dbref}.size
				else
					0
				end
		m =	case num_unread
			when 0: nil
			when 1: "%|15|Newsbot Notification:%|0| There is  %|15|1%|0| new news item. Type %|11|+news%|0| to read it."
			else
				"%|15|Newsbot Notification:%|0| There are %|15|#{num_unread}%|0| new news items. Type %|11|+news%|0| to read them."
			end
		return (m and NewsMessage.new{|n| n.message = m})
	end
end
