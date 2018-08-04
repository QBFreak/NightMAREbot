=begin
	This plugin allows Thorog to update the database remotely,
	scping the file into place and running a shiny plugin to
	run it, then deleting the update file so I can't screw
	everything over.
=end

Command.new do
	name	"Update"
	desc	"Allows admins to update the newsboard"
	help <<-eof
		This command allows Thorog to update the newsboard from a file update.rb. Unless
		you are Thorog you will never need to worry about this command.
	eof
	syntax	"+news update"
	match(/^update$/)
	trigger do
		if $CALLER != '#5'
			next NewsMessage.new{|n| n.message = "This function is restricted to Thorog only."}
		elsif not File.exists? "update.rb"
			next NewsMessage.new{|n| n.message = "There is no update script to run."}
		end
	end
end
