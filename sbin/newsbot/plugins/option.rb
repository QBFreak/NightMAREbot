=begin
	Allows you to check and set options.
=end

Command.new do
	name	"Options"
	desc	"Allows you to check and set options"
	syntax	"+news options [<option>[=<value>]]"
	help <<-eof
		There are a couple of ways you can use this:
		%|11|+news options
		This will display all your set options, including defaults.
		%|11|+news options %|12|<option>
		This will only display what you have set for %|12|option%|0|, but will also give
		the allowed values this option may hold.
		%|11|+news options %|12|<option>%|11|=%|12|<value>
		This will set %|12|option%|0| to %|11|value%|0|. If value isn't allowed it will
		tell you.
	eof

	match(/^options(?: (.*?)(?:=(.*))?)?$/)

	trigger do |match|
		opts = $DATA[:options]
		unless opts.has_key? $CALLER
			opts[$CALLER] = Option.new		
			$DIRTY << :options
		end
		
		#Check what we want
		case nil
		when match[1]
			next NewsMessage.new{|n| n.message = "All options:\n" + opts[$CALLER].to_s}
		when match[2]
			opt = match[1].to_sym
			message = "%|11|Option:|0| #{opt}\n"
			begin
				message << "%|11|Current value:%|0|" << opts[$CALLER][opt].to_s << "\n"
				message	<< "%|11|Allowed values:%|0|" << Option.allowed[opt].join(', ') if
						Option.allowed.has_key? opt
			rescue ArgumentError
				next NewsMessage.new{|n| n.message = "There is no option %|11|#{match[1]}%|0|."}
			else	
				next NewsMessage.new{|n| n.message = message}
			end
		else
			begin
				opts[$CALLER][match[1].to_sym] = match[2].to_sym
			rescue ArgumentError
				next NewsMessage.new{|n| n.message = "%|11|#{match[2]} is an invalid value for the option %|11|#{match[1]}%|0|."}
			else
				next NewsMessage.new{|n| n.message = "Option %|11|#{match[1]}%|0| set to %|11|#{match[2]}%|0|."}
			end
		end
	end
end
