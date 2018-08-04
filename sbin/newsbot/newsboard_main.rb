=begin
	The "proper" newsboard code.
	A lot of exceptional circumstances are dealt with in newsboard_pre.
	If that runs correctly without exiting us to shell, we run this file
	as the "proper" newsboard code.
=end

#requires
#News stuff
require_relative 'lib/news_base'
require_relative 'lib/news_message'
require_relative 'lib/news_item'

#Constants and useful stuff
require_relative 'lib/constants'
require_relative 'lib/util'
require_relative 'lib/options'
require_relative 'lib/on_connect'

#Encoding and communication modules
require_relative 'lib/coder'
require_relative 'lib/io'

#Auxiliary structures
require_relative 'lib/help'
require_relative 'lib/command'

#Main error-checking/catching loop
begin

	raise ArgumentError, "Not enough variables given" unless ARGV.size == 2

	#globals
	$CALLER = Coder::decode(ARGV.shift)
	$DATA = {}
	Dir["data/*.nb"].each do |f|
		f =~ /data\/(.*)\.nb/
		File.open(f){|file| $DATA[$1.to_sym] =  Marshal.load(file)}
	end
	$DIRTY=[]

	#Check everything exists
	unless $DATA.has_key? :news
		$DATA[:news] = NewsBase.new
		$DIRTY << :news
	end

	unless $DATA.has_key? :stickies
		$DATA[:stickies] = []
		$DIRTY << :stickies
	end

	unless $DATA.has_key? :moderators
		$DATA[:moderators] = ["#5"]
		$DIRTY << :moderators
	end

	unless $DATA.has_key? :options
		$DATA[:options] = {}
		$DIRTY << :options
	end
	
	#load help
	HelpTopic.load

	#load commands
	Command.load
	
	#Run actual code!
	argument = Coder.decode ARGV.shift
	if argument =~ /^aconnect/
		s = OnConnect::run
	else
		s = if argument.index(' ') == nil
			Command::filter_all('')
		else
			Command::filter_all(argument[(argument.index(' ')+1)..-1])	#don't need news bit
		end
	end
rescue Exception => e
	string = "An error was encountered:%r#{e.class}: #{e.message} @ #{e.backtrace[0]}%rPlease page QBFreak or Thorog, or, if both are offline, +mail one or both."
	arr = [
		NewsMessage.new{|n| n.message = string},
		NewsMessage.new do |n|
			n.dbref = "#5"
			n.message = string
		end,
		NewsMessage.new do |n|
			n.dbref = "#2484"
			n.message = string
		end
	]
	BotIO.output arr
	BotIO.log_error e
else
	BotIO::output s unless s.nil?
	
	$DIRTY.uniq.each do |val|
		File.open("data/#{val}.nb",'w'){|f| f << Marshal.dump($DATA[val])}
	end
end
