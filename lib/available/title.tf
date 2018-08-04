;/def -Fp1 -mregexp -t'^\\[([^ ]+)\\].*(http://[^ <>;|]*)' gettitle = /quote -w$[world_info()] title %{P1} !"~/sbin/title/gettitle.pl %{P2}"

/def -Fp1 -E'{enabled_title}' -mregexp -t'^\\[([^ ]+)\\] ([^ :]+).*(http://[^ <>;|]*)' gettitle = \
    /if (%gag_title) \
        /set gag_title=0%; \
    /else \
	/let title_channel_temp %{P1}%; \
	/let title_player_temp %{P2}%; \
	/let title_url_temp $[textencode({P3})]%; \
	/if ($[tolower({title_player_temp})] !~ $[tolower(world_info('character'))]) \
		/quote -w$[world_info()] title %{title_channel_temp} !"~/sbin/title/gettitle.pl %{title_url_temp}"%; \
	/endif %; \
    /endif

/def -Fp1 -E'{enabled_title}' -mregexp -t'^\\[([^ ]+)\\] ([^ :]+).*(https://[^ <>;|]*)' gettitles = \
    /if (%gag_title) \
        /set gag_title=0%; \
    /else \
	/let title_channel_temp %{P1}%; \
	/let title_player_temp %{P2}%; \
	/let title_url_temp $[textencode({P3})]%; \
	/if ($[tolower({title_player_temp})] !~ $[tolower(world_info('character'))]) \
		/quote -w$[world_info()] title %{title_channel_temp} !"~/sbin/title/gettitle.pl %{title_url_temp}"%; \
	/endif %; \
    /endif

/def remove_title = \
    /undef gettitle %; \
    /undef gettitles %; \
    /unset enabled_title %; \
    /unset gag_title %; \
    /unset installed_title %; \
    /purge *_title %; \
    /echo % TITLE: removed

/set installed_title=1
/set enabled_title=1
/set gag_title=0
/echo % TITLE: installed
