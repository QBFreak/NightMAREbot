=begin
	The parent for the NewsItem and NewsBase classes.
=end

require_relative 'tree'
require_relative 'util'

class NewsParent
	include Tree

	alias_method	:replies,	:children
	alias_method	:replies=,	:children=

	def initialize
		@children = []
	end

	#Deletes a post - if the post is the last post
	#on the list and has no children, it really gets
	#deleted. Otherwise it gets locked and title/body
	#get removed.
	def delete post
		$DIRTY << :news
		post = @children[post] if post.kind_of? Integer
		raise ArgumentError, "Post not found" unless @children.include? post

		if @children[-1] == post and post.children.size == 0
			@children.delete post
		else
			post.title = "<Deleted>"
			post.body = "<Post deleted>"
			post.drill(true){|b| b.locked = true}
		end

		post.sticky = false if post.sticky
	end

	#Traverse modified because indices are one off.
	def traverse index_array
		return self if index_array.size == 0
		child = index_array.shift
		return nil if child > @children.size
		return @children[child - 1].traverse(index_array)
	end
end
