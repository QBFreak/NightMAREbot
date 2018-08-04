=begin
	The commands help thingy
=end

InteractiveHelpTopic.new do
	name	"Commands"
	desc	"List of all commands"
	help	'Command::commands.map{|c| "%|11|#{c.name}%|0|: #{c.desc}"}.join("\n")'
end
