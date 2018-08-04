=begin
	Stuff like the about topic, feedback, etc.
=end

HelpTopic.new do
	name	"About"
	desc	"Technical details"
	help <<-eof
		NewsBoard exists in two pieces - the frontend is coded by QBFreak and uses
		tinyMARE/tinyfugue code to detect newsboard queries and forward them (through
		tinyfugue) to the backend. The backend is coded in Ruby version #{RUBY_VERSION}
		by Thorog.
	eof
end

HelpTopic.new do
	name	"Feedback"
	desc	"How to have your say"
	help <<-eof
		So you want to have your say in how NewsBoard works? You're in luck. NewsBoard
		is actively developed by Thorog, and so if you have a good suggestion for
		improving how NewsBoard works, there's a good chance it will get put in.
		Similarly, if you find any bugs, please contact him. If he's online, feel free
		to drop him a page. If not, please +mail him.
	eof
end
