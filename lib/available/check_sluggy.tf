;;; Sluggy NightMAREbot module

; Settings
;/set check_sluggy_var MyValue

; Start out disabled so nothing happens while we're loading
/set check_sluggy_enabled 0


;;; CHECK_SLUGGY code management
; Enable check_sluggy command
/def enable_check_sluggy = \
	/echo % CHECK_SLUGGY: Enabling CHECK_SLUGGY %; \
	/set check_sluggy_enabled 1

; Disable check_sluggy command
/def disable_check_sluggy = \
	/echo % CHECK_SLUGGY: Disabling CHECK_SLUGGY %; \
	/set check_sluggy_enabled 0

; Remove all CHECK_SLUGGY code
/def remove_check_sluggy = \
	/disable_check_sluggy %; \
	/unset check_sluggy_enabled %; \
;	/unset check_sluggy_var %; \
	/unset installed_check_sluggy %; \
	/undef check_sluggy %; \
	/purge check_sluggy_* %; \
	/purge *_check_sluggy %; \
        /echo % CHECK_SLUGGY: removed

; CHECK_SLUGGY status
/def check_sluggy_status = \
	/if ({check_sluggy_enabled}) \
		/echo % CHECK_SLUGGY: CHECK_SLUGGY module is enabled. %; \
	/else \
		/echo % CHECK_SLUGGY: CHECK_SLUGGY module is disabled. %; \
	/endif


;;; Core code
; Hooks, triggers, and other commands go here
/def -Fp1 -ag -mregexp -t'^CHECK_SLUGGY$' check_sluggy_trigger = \
	/quote -w$[world_info()] CHECK_SLUGGY %{check_sluggy_channel_temp} !"~/sbin/sluggy/check_sluggy.sh"


;;; Management command
/def check_sluggy = \
	/if ({1} =/ '') \
		/echo % CHECK_SLUGGY: NightMAREbot CHECK_SLUGGY module, written by Jason Hill (qbfreak@qbfreak.net) %; \
		/echo % CHECK_SLUGGY: This module checks the Sluggy Freelance website for updates and new comics. %; \
	/elseif ({1} =/ 'enable') \
		/enable_check_sluggy %; \
	/elseif ({1} =/ 'disable') \
		/disable_check_sluggy %; \
	/elseif ({1} =/ 'status') \
		/check_sluggy_status %; \
	/elseif ({1} =/ 'remove') \
		/remove_check_sluggy %; \
	/else \
		/echo % CHECK_SLUGGY: '%{1}' is not a valid option. %; \
		/echo % CHECK_SLUGGY: Valid options are: enable disable status remove %; \
	/endif

;;;; All set, start it up
/set installed_check_sluggy=1
/echo % CHECK_SLUGGY: installed
/enable_check_sluggy
