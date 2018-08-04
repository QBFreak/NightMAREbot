=begin
	This plugin allows QBFreak or Thorog to enable/disable
	the newsboard as required. This is a pretty strong enable/
	disable - if disabled, nothing will be loaded. This is useful
	for when new code needs to be thrown in, but there are several
	things which need to be thrown in and one may break everything
	on its own.
=end

Command.new do
	name	"Disable"
	desc	"Allows admins to disable the newsboard for upgrades"
	help <<-eof
		This plugin allows Thorog or QBFreak to disable the newsboard.
		This will generally be used for when one of them wish to upgrade the newsboard,
		thus preventing users from managing to access it mid-upgrade, screwing things up.
	eof
	syntax	"+news disable"

	match(/^disable/)

	trigger do
		if ["#5", "#2484"].include? $CALLER
			File.open("frozen",'w'){}
			next NewsMessage.new{|n| n.message = "Newsboard disabled. Type +news enable to enable again."}
		else
			next NewsMessage.new{|n| n.message = "Bad user. No cookie."}
		end
	end
end
