=begin
	The Tree module can be included to give
	"tree"-type functionality, including children
	and several "drilling" methods.
=end

module Tree
	#NB: @children should be set to [] in initialize
	attr_accessor	:children
	@children = []

	#Allows access to the children property much more easily
	#for various methods.

	#Allows access to children[]
	def [] index
		@children[index]
	end

	#Allows access to children[]=
	def []= index, value
		@children[index] = value
	end

	#Allows access to children<<
	def << new_child
		@children << new_child
	end

	#Easy access to size
	def size
		@children.size
	end

	#"Drills down" through the tree, performing
	#the block on each child of this node.
	#Will not run on the caller if call_on_self
	#is set to false.
	def drill call_on_self=true, &blck
		blck.call self if call_on_self
		@children.each{|child| child.drill &blck}
	end

	#Similar to Tree#drill, but supplies a depth along with
	#the drill, indicating how many layers have been drilled.
	#The args hash can take two values:
	#	:start_depth	The value that depth starts at.
	#			Default is set so that the first level
	#			evaluated has depth 0.
	#	:no_self_call	If args contains this, the parent object
	#			will not be called.
	#--
	#TODO: Tidy up? Remove args requirement?
	def drill_with_depth args={}, &blck
		args[:start_depth] ||= (args.has_key?(:no_self_call) ? -1 : 0)
		blck.call self, args[:start_depth] unless args.has_key? :no_self_call
		@children.each do |child|
			child.drill_with_depth(
					{:start_depth	=> args[:start_depth] + 1},
					&blck
			)
		end
	end

	#Similar to Tree#drill, but passes a value around the tree.
	def drill_inject start_value,call_self=true, &blck
		start_value = blck.call(start_value, self) if call_self
		children.each do |child|
			start_value = child.drill_inject(start_value, &blck)
		end
		start_value
	end

	#Iterates over all children
	def each_child &blck
		@children.each{|child| blck.call(child)}
	end

	#Allows you to find a node in the tree, given an array of indices
	#Returns nil if the path does not exist.
	def traverse index_arr
		return self if index_arr.size == 0
		ref = index_arr.shift
		if ref < @children.size
			return @children[ref].traverse(index_arr)
		else
			return nil
		end
	end
end
