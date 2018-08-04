=begin
	This represents a news item. It contains
	a title, body, post time and date, author,
	array of people who have read it and array
	of replies.
=end

require_relative 'news_parent'
require_relative 'util'

class NewsItem < NewsParent
	
	#Standard properties
	attr_accessor	:title,	:body,	:author,	:posted_at,	:read, :index, :num_times_edited,	:last_edited, :locked
	attr_reader	:sticky

	#init code
	def initialize
		super
		@read = []
		@num_times_edited = 0
		@last_edited = 0
		yield self if block_given?
		#TODO: Do we need error checking in here?
		@read << @author if @read.size ==0 and not @author.nil?
		@posted_at ||= Time.now.getutc
		@locked = false
		@sticky = false
		$DIRTY << :news
	end

	#Finds the parent of the post
	def parent
		if index.size == 1
			$DATA[:news]
		else
			Util::get_post @index[0..-2]
		end
	end
	
	def sticky= new_value
		raise ArgumentError, "Value NewsItem#sticky must be true or false" unless [true, false].include? new_value
		unless new_value == @sticky
			$DIRTY << :stickies << :news
			@sticky = new_value
			if new_value == true
				$DATA[:stickies] << @index
			else
				$DATA[:stickies].delete @index
			end
		end
	end

	##Space-saving MARECode commands

	#MAREcode fetches the author name
	def aname
		"[name(#{@author})]"
	end

	#MAREcode fetches the author colour
	def acolour
		"get(#{@author},color)"
	end
	
	#Favoured time string
	#--
	#TODO: Add preferences for this?
	def time_string time
		time.strftime "%Y-%m-%d %H:%M"
	end

	#Returns true if the caller has read this post
	def read_by? dbref=$CALLER	
		read.include? dbref
	end

	#Adds the caller to the read list if they aren't already
	def was_read_by dbref=$CALLER
		unless read.include? dbref
			read << dbref
			$DIRTY << :news
		end
	end

	#Marks this post and its children read.
	def mark_all_read dbref=$CALLER
		$DIRTY << :news
		drill{|p| p.was_read_by dbref}
	end

	#Checks the number of unread replies
	def num_unread_replies count_self, dbref=$CALLER
		drill_inject(0,count_self){|sum,r| r.read_by?(dbref) ? sum : sum + 1}
	end
	
	#Finds the total number of children - replies, and replies to those replies, and so on
	def num_children
		drill_inject(0, false){|size,p| size + 1}
	end

	#For display in lists:
	def short_display dbref=$CALLER
		"#{(num_unread_replies(true, dbref) == 0)  ? '' : '[esc(7m)]'}#{index[-1]})[esc(0m)] #{(read_by?(dbref) ? '' : '[NEW] ')}" + Util::make_coloured("[esc(#{read_by?(dbref) ? '2' : '1'}m)]#{title} (#{aname}, #{num_children} repl#{num_children == 1 ? 'y' : 'ies'} | #{num_unread_replies(false, dbref)} unread)",@author)
	end

	#For full display
	def display dbref=$CALLER
		return_string = Util::make_coloured("[esc(1m)]#{index.join('/')}. #{title}[esc(2m)] by #{aname} @ #{time_string posted_at}",@author)
		return_string << '%r' << body
		other_stuff = ''
		other_stuff << "%r%|15|Edited #{num_times_edited} time#{num_times_edited == 1 ? '' : 's'}, last at #{time_string last_edited}%|0|" if num_times_edited > 0
		if replies.size > 0
			other_stuff << '%r' << 'Replies:'
			replies.each{|r| other_stuff << '%r%t' << r.short_display(dbref)}
		end
		other_stuff << "%rThread locked." if locked
		unless other_stuff == ''
			return_string << '%r' << other_stuff
		end
		return return_string
	end
end
