=begin
	Plugins dealing mainly with displaying helptext
=end

Command.new do
	name	"Help"
	desc	"Displays contextual help."
	help <<-eof
	The help command is used to find help. There are four main uses of the help
	command:
	%|11|help%|0|
	Displays the main help screen, including a list of basic help topics.
	%|11|help <topic>%|0|
	Displays help on a topic in particular.
	%|11|help commands%|0|
	Displays all commands available.
	%|11|help <command>%|0|
	Displays more verbose help on a particular command.
	Any of these can be accessed by typing %|11|+news%|0| followed by whatever
	command you want. You don't have to type the whole command, usually part of
	it will do.
	eof
	syntax	"+news help [topic|command]"
	
	match(/^help( .+)?/)
	trigger do |match|
		if match[0] =~ /^help (.+)/
			matches = HelpTopic::find($1)
			case matches.size
			when 0:	next NewsMessage.new{|n| n.message = "No help found on that topic."}
			when 1: next NewsMessage.new{|n| n.message = matches[0].to_s(:long)}
			else
				next NewsMessage.new{|n| n.message = "Multiple topics match your search: " + matches.map{|c| c.name}.join(", ") + "."}
			end
		else
			next NewsMessage.new do |n|
				n.message = HelpTopic.help_topics.inject("%|11|Help topics%|0| (type %|11|+news help help%|0| for how to use this)") do |string,ht|
					if ht[1].kind_of?(Command)
						string
					else
						string + "\n" + ht[1].to_s(:short)
					end
				end
			end
		end
	end
end
