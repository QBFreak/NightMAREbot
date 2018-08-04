=begin
	Used because I tire of typing scp all the time
=end

puts "Please execute from its location" unless File.dirname($0) == '.'

if ARGV.size == 0
	puts <<-eof
Please select one:
1.	Sync lib/*
2.	Sync plugins/*
3.	Sync *.rb
eof
	input = ''
	begin
		print "Please select one: "
	end until (1..3).include?(input = STDIN.gets.to_i)
	c_string =	case input
			when 1:	["lib/*","lib/"]
			when 2: ["plugins/*","plugins/"]
			when 3: ["*.rb",'']
			else
				exit
	end
	string = "scp -P 10022 #{c_string[0]} nightmarebot@qbfreak.dyndns.org:sbin/newsbot/#{c_string[1]}"
	puts "Now attempting: #{string}"
	`#{string}`
else
	until ARGV.size == 0
		path = ARGV.shift

		rel_path = ''
		if File.dirname($0) == '.'
				rel_path = path
			else
				dir = File.dirname($0)
				if path =~ /^#{dir}\/(.*)/
					rel_path = $1
				else
					puts "Must be relative path"
					exit
				end
			end

		string = "scp -P 10022 #{path} nightmarebot@qbfreak.dyndns.org:sbin/newsbot/#{rel_path}"
		puts "Now attempting: #{string}"
		`#{string}`
	end
end
puts "Syncing done!"
