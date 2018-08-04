/def -Fp1 -ag -mregexp -t'^GETUSAGE ([^ <>;|]+) ([^ <>;|]+)' getusage = /quote -w$[world_info()] usage %{P1} !"~/sbin/usage/getusage.pl %{P2}"

/def remove_usage = \
	/undef getusage %; \
	/unset installed_usage %; \
	/undef remove_usage %; \
	/echo % USAGE: removed

/set installed_usage=1
/echo % USAGE: installed
