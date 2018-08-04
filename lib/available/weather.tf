/def -Fp1 -ag -mregexp -t'^GETICAO ([^ <>;|]+) ([^ <>;|]+) ([^ <>;|]+)' geticao = \
	/quote -w$[world_info()] ICAO %{P1} !"~/sbin/weather/geticao.sh %{P2} %{P3}"
	
/def -Fp1 -ag -mregexp -t'^GETWEATHERICAO ([^ <>;|]+) ([^ <>;|]+)' getweathericao = \
	/quote -w$[world_info()] WEATHERICAO %{P1} !"~/sbin/weather/getweathericao.sh %{P2}"
	

/def -Fp1 -ag -mregexp -t'^GETWEATHERLOC ([^ <>;|]+) ([^ <>;|]+) ([^ <>;|]+)' getweatherloc = \
	/quote -w$[world_info()] WEATHERLOC %{P1} !"~/sbin/weather/getweatherloc.sh %{P2} %{P3}"
	
/def remove_weather = \
	/undef geticao %; \
	/undef getweathericao %; \
	/undef getweatherloc %; \
	/undef remove_spell %; \
	/echo % WEATHER: removed

/echo % WEATHER: installed
