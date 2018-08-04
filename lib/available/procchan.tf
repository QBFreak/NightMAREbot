/def -Fp1 -mregexp -Tdiku -t'^\\[[^ ]+\\] .*' procchan = procchan %*
/def remove_procchan = \
	/undef procchan %; \
	/unset installed_procchan %; \
	/undef remove_procchan %; \
	/echo % PROCCHAN: removed

/set installed_procchan=1
/echo % PROCCHAN: installed
