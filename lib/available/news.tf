;;; News NightMAREbot module

;; Update author, email address and module description

; Settings
/set news_var MyValue

; Start out disabled so nothing happens while we're loading
/set news_enabled 0


;;; NEWS code management
; Enable news command
/def enable_news = \
	/echo % NEWS: Enabling NEWS %; \
	/set news_enabled 1

; Disable news command
/def disable_news = \
	/echo % NEWS: Disabling NEWS %; \
	/set news_enabled 0

; Remove all NEWS code
/def remove_news = \
	/disable_news %; \
	/unset news_enabled %; \
	/unset news_var %; \
	/unset installed_news %; \
	/undef news %; \
	/purge news_* %; \
	/purge *_news %; \
        /echo % NEWS: removed

; NEWS status
/def news_status = \
	/if ({news_enabled}) \
		/echo % NEWS: NEWS module is enabled. %; \
	/else \
		/echo % NEWS: NEWS module is disabled. %; \
	/endif


;;; Core code
; Hooks, triggers, and other commands go here
/def -Fp1 -ag -mregexp -E{news_enabled} -t'^NEWS #([0-9]+) ([^<>;|]+)$' news_trigger = \
	/let news_dbref_temp _35_%{P1}%; \
	/let news_param_temp $[textencode({P2})]%; \
	/quote -w$[world_info()] -S NEWS !"/usr/bin/ruby ~/sbin/newsbot/newsboard.rb %{news_dbref_temp} %{news_param_temp}"


;;; Management command
/def news = \
	/if ({1} =/ '') \
		/echo % NEWS: NightMAREbot +news module, written by Jason Hill (qbfreak@qbfreak.net) %; \
		/echo % NEWS: Put a brief module description here. %; \
	/elseif ({1} =/ 'enable') \
		/enable_news %; \
	/elseif ({1} =/ 'disable') \
		/disable_news %; \
	/elseif ({1} =/ 'status') \
		/news_status %; \
	/elseif ({1} =/ 'remove') \
		/remove_news %; \
	/else \
		/echo % NEWS: '%{1}' is not a valid option. %; \
		/echo % NEWS: Valid options are: enable disable status remove %; \
	/endif

;;;; All set, start it up
/set installed_news=1
/echo % NEWS: installed
/enable_news
