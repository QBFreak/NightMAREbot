#!/usr/bin/env ruby
=begin
	Contains all the actual stuff.
	TODO:
	* Move aconnect into its own plugin?
	* moderator lock/unlock command
	* +news unread
	* Add dirtifying in interior code - metaprogram
=end

#Don't forget to change!
$VERSION = "2.0RC1"

### Version History
##2.0 RC1
#Options class
#Syntax colouring
#Redid entire news_item structure, implemented Tree module.
#Many code changes.
#Public Beta!
##2.0b9
#Considered custom storage solution
##2.0b8
# Considered YAML as a possible storage solution - too slow
#Added help and created InteractiveHelpTopic
#Cleaned up deleted post index problems
#Cleaned up news_item, fixed dig_inject
##2.0b7
# New help! Yet to actually populate with help topics.
# Loading/dirty improved significantly
# Stuff split into newsboard_pre and newsboard_main
##2.0b6
#Added shiny showfull command, for shiny.
#Added moderator commands
##2.05b5
#History started
#Separated news into three files
#Implemented update script
#Added edit function
#Added the ability to disable/enable

#Set path
Dir.chdir(File.dirname($0)) unless File.dirname($0) == ''

#Run pre-program checklist
require_relative 'newsboard_pre'

#Run program!
require_relative 'newsboard_main'
