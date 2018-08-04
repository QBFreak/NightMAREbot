=begin
	This is the pre-run code. A lot of this will run
	if there is an exceptional circumstace, such as
	upgrading taking place, in which case we don't really
	want to run everything.
=end

################
## This code is run if:
## a. We are "frozen" (+news disable has been run by QBFreak or Thorog)
## b. I'm (Thorog) updating the database
## It prevents everything else loading, since in both of these cases
## we probably don't want people screwing around with data or stuff
## loading and being mangled.
################

#Check for enabling
if ARGV[1] == "_43_news_32_enable" and
	ARGV[0] =~ /_35_(5|2484)/
	if File.exists? 'frozen'
		File.delete "frozen"
		printf "_35_#$1 Newsboard_32_enabled_46_"
	else
		printf "_35_#$1 Newsboard_32_already_32_enabled_46_"
	end
	exit
end

#Check for Thorog updating
if ARGV[0] == "_35_5" and ARGV[1] == "_43_news_32_update" and File.exists? "update.rb"
	`ruby update.rb`
	File.delete "update.rb"
	printf "_35_5 Update_32_complete_46_"
	exit
end

#Check for frozen:
if File.exists? "frozen"
	printf "#{ARGV[0]} The_32_news_32_database_32_is_32_currently_32_frozen_46__32_Please_32_try_32_again_32_later_46_"
	exit
end


## None of those run? Into proper code.
