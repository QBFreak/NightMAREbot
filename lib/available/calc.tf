;;; Calc NightMAREbot module

; Settings
/set calc_var MyValue

; Start out disabled so nothing happens while we're loading
/set calc_enabled 0


;;; CALC code management
; Enable calc command
/def enable_calc = \
	/echo % CALC: Enabling CALC %; \
	/set calc_enabled 1

; Disable calc command
/def disable_calc = \
	/echo % CALC: Disabling CALC %; \
	/set calc_enabled 0

; Remove all CALC code
/def remove_calc = \
	/disable_calc %; \
	/unset calc_enabled %; \
	/unset calc_var %; \
	/unset installed_calc %; \
	/undef calc %; \
	/purge calc_* %; \
	/purge *_calc %; \
        /echo % CALC: removed

; CALC status
/def calc_status = \
	/if ({calc_enabled}) \
		/echo % CALC: CALC module is enabled. %; \
	/else \
		/echo % CALC: CALC module is disabled. %; \
	/endif


;;; Core code
; Hooks, triggers, and other commands go here
/def -Fp1 -ag -mregexp -t'^CALC ([^ <>;|]+) ([^<>;|]+)$' calc_trigger = \
	/set calc_channel_temp %{P1}%; \
	/set calc_param_temp $[textencode({P2})]%; \
	/echo % CALC: channel: %{calc_channel_temp} %; \
	/echo % CALC: param: %{calc_param_temp} %; \
	/quote -w$[world_info()] CALC %{calc_channel_temp} !"~/sbin/calc/calc.pl %{calc_param_temp}"%; \
	/unset calc_param_temp %; \
	/unset calc_channel_temp


;;; Management command
/def calc = \
	/if ({1} =/ '') \
		/echo % CALC: NightMAREbot CALC module, written by Jason Hill (qbfreak@qbfreak.net) %; \
		/echo % CALC: Simple calculator module using linux's bc command %; \
	/elseif ({1} =/ 'enable') \
		/enable_calc %; \
	/elseif ({1} =/ 'disable') \
		/disable_calc %; \
	/elseif ({1} =/ 'status') \
		/calc_status %; \
	/elseif ({1} =/ 'remove') \
		/remove_calc %; \
	/else \
		/echo % CALC: '%{1}' is not a valid option. %; \
		/echo % CALC: Valid options are: enable disable status remove %; \
	/endif

;;;; All set, start it up
/set installed_calc=1
/echo % CALC: installed
/enable_calc
