;;; NightMAREbot bugs module
;;; QBFreak <qbfreak@qbfreak.net>
;;; Interfaces with Foswiki's BugsContrib bug tracking system

; Start out disabled so nothing happens while we're loading
/set bugs_enabled 0


;;; BUGS code management
; Enable bugs command
/def enable_bugs = \
	/echo % BUGS: Enabling BUGS %; \
	/set bugs_enabled 1

; Disable bugs command
/def disable_bugs = \
	/echo % BUGS: Disabling BUGS %; \
	/set bugs_enabled 0

; Remove all BUGS code
/def remove_bugs = \
	/disable_bugs %; \
	/unset bugs_enabled %; \
	/unset installed_bugs %; \
	/undef bugs %; \
	/purge bugs_* %; \
	/purge *_bugs %; \
        /echo % BUGS: removed

; BUGS status
/def bugs_status = \
	/if ({bugs_enabled}) \
		/echo % BUGS: BUGS module is enabled. %; \
	/else \
		/echo % BUGS: BUGS module is disabled. %; \
	/endif


;;; Core code
; Hooks, triggers, and other commands go here
/def -Fp1 -ag -mregexp -E{bugs_enabled} -t'^BUGS new$' bugs_trigger = \
	/quote -w$[world_info()] -S BUGS !"/usr/bin/perl ~/sbin/bugs/getbugs.pl"

/def -Fp1 -ag -mregexp -E{bugs_enabled} -t'^BUGS rss$' bugs_rss_trigger = \
    /quote -w$[world_info()] -S BUGS_RSS !"/usr/bin/perl ~/sbin/bugs/foswikirss.pl --encode"


;;; Management command
/def bugs = \
	/if ({1} =/ '') \
		/echo % BUGS: NightMAREbot !bugs module, written by Jason Hill (qbfreak@qbfreak.net) %; \
		/echo % BUGS: Interfaces with Foswiki's BugsContrib bug tracking system. %; \
	/elseif ({1} =/ 'enable') \
		/enable_bugs %; \
	/elseif ({1} =/ 'disable') \
		/disable_bugs %; \
	/elseif ({1} =/ 'status') \
		/bugs_status %; \
	/elseif ({1} =/ 'remove') \
		/remove_bugs %; \
	/else \
		/echo % BUGS: '%{1}' is not a valid option. %; \
		/echo % BUGS: Valid options are: enable disable status remove %; \
	/endif

;;;; All set, start it up
/set installed_bugs=1
/echo % BUGS: installed
/enable_bugs
