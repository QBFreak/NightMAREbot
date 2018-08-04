=begin
	Contains several methods to display posts in various ways.
=end

class NewsCommand < Command
	def display_news news_array
		news_array = get_news_from news_array if news_array.kind_of? Integer
		return news_array.map{|n| n.short_display}.join("\n")
	end

	def get_news_from index=-1
		p_arr = []
		if index == -1
			($DATA[:news].size-1).downto(0) do |i|
				unless $DATA[:news][i].sticky
					p_arr << $DATA[:news][i]
					break if p_arr.size == 15
				end
			end
			return p_arr
		else
			index.upto($DATA[:news].size-1) do |i|
				unless $DATA[:news][i].sticky
					p_arr << $DATA[:news][i]
					break if p_arr.size == 15
				end
			end
			return p_arr.reverse
		end
	end

	def prefix with_stickies = true
		title_string = 'newsboard_daemon_' +	#now get mods!
		if $DATA[:options][$CALLER][:color] == :off
			'mono_'
		elsif Time.now.month == 12
			'christmas_'
		else
			''
		end + 'title'
		str = Util::from_daemon(title_string) + "\n"
		
		str << Constants::TITLE
		str << "Sticky threads:" << "\n" << display_news($DATA[:stickies].map{|n| Util::get_post(n.to_s)}.reverse) << "\n" << Constants::DIVIDER if
				with_stickies and
				$DATA[:stickies].size > 0
		return str
	end

	private :display_news, :get_news_from, :prefix
end


NewsCommand.new do
	name	"Show news"
	desc	"Shows recent news posts"
	help <<-eof
		This shows you the last 15 news posts. New news posts have [NEW] in front of
		them, and the index of posts that are either new or have unread replies is
		highlighted.
	eof
	syntax	"+news"
	match(/^$/)
	trigger do
		next NewsMessage.new{|n| n.message = prefix + display_news(-1)}
	end
end

NewsCommand.new do
	name	"History"
	desc	"Show older news posts"
	help <<-eof
		This command allows you to look back in the news beyond that shown by a simple
		+news. The post number you give will be the first one in the list - the next 15
		will also be displayed.
	eof
	syntax	"+news hist=<post number>"
	
	match(/^hist=(\d+)/)
	
	trigger do |match|
		next NewsMessage.new{|n| n.message = prefix(false) + display_news($1.to_i - 1)}
	end
end

NewsCommand.new do
	name	"Show full"
	desc	"Shows posts as a \"tree\""
	help <<-eof
		With this command you may examine posts as a "tree" rather than a plain list.
		Replies to posts are shown indented below the post itself, with replies to them
		further indented, and so on. A post path can be included - if so, you will get
		just that post and its children. Note that if there are over 15 replies to a
		post they will all be shown, and that they are not shown in reverse order as
		news posts are normally.
	eof
	syntax	"+news full [post path]"

	match(/^full( #{Constants::PATH_TO_POST})?/)
	trigger do |match|
		r_string = ''
		if match[1].nil?
			r_string = prefix
			p_arr = get_news_from -1
			p_arr.each do |news|
				news.drill_with_depth do |article, i|
					r_string << ('%t' * i) << article.short_display << '%r'
				end
			end
		else
			r_string = prefix(false)
			p = Util::get_post match[1][1..-1]	#remove space
			next Constants::ERR_NOT_FOUND if p.nil?
			p.drill_with_depth do |article, i|
				r_string << ('%t' * i) << article.short_display << '%r'
			end
		end
		next NewsMessage.new{|n| n.message = r_string}
	end
end

NewsCommand.new do
	name	"Show unread"
	desc	"Shows the latest 15 news posts with unread content"
	help <<-eof
		With this command you may see the last 15 posts that contain unread content.
		Unread content basically means any posts that you haven't read, or have unread
		replies.
	eof
	syntax	"+news unread"
	match(/^unread/)
	trigger do
		arr = []
		($DATA[:news].size - 1).downto(0) do |i|
			n = $DATA[:news][i]
			arr << n if n.num_unread_replies(true) > 0
			break if arr.size > 14
		end
		next NewsMessage.new{|n| n.message = prefix(false) + display_news(arr)}
	end
end
