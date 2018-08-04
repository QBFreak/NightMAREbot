;;; Template NightMAREbot module

;: Replace all occurances of template and TEMPLATE with the name of your module (in the correct case)
;; Update author, email address and module description

; Settings
/set template_var MyValue

; Start out disabled so nothing happens while we're loading
/set template_enabled 0


;;; TEMPLATE code management
; Enable template command
/def enable_template = \
	/echo % TEMPLATE: Enabling TEMPLATE %; \
	/set template_enabled 1

; Disable template command
/def disable_template = \
	/echo % TEMPLATE: Disabling TEMPLATE %; \
	/set template_enabled 0

; Remove all TEMPLATE code
/def remove_template = \
	/disable_template %; \
	/unset template_enabled %; \
	/unset template_var %; \
	/unset installed_template %; \
	/undef template %; \
	/purge template_* %; \
	/purge *_template %; \
        /echo % TEMPLATE: removed

; TEMPLATE status
/def template_status = \
	/if ({template_enabled}) \
		/echo % TEMPLATE: TEMPLATE module is enabled. %; \
	/else \
		/echo % TEMPLATE: TEMPLATE module is disabled. %; \
	/endif


;;; Core code
; Hooks, triggers, and other commands go here
/def -Fp1 -ag -mregexp -t'^TEMPLATE ([^ <>;|]+) ([^<>;|]+)$' template_trigger = \
	/set template_channel_temp %{P1}%; \
	/set template_param_temp $[textencode({P2})]%; \
	/quote -w$[world_info()] TEMPLATE %{template_channel_temp} !"~/sbin/template/template.pl %{template_param_temp}"
	/unset template_param_temp %; \
	/unset template_channel_temp


;;; Management command
/def template = \
	/if ({1} =/ '') \
		/echo % TEMPLATE: NightMAREbot TEMPLATE module, written by Jason Hill (qbfreak@qbfreak.net) %; \
		/echo % TEMPLATE: Put a brief module description here. %; \
	/elseif ({1} =/ 'enable') \
		/enable_template %; \
	/elseif ({1} =/ 'disable') \
		/disable_template %; \
	/elseif ({1} =/ 'status') \
		/template_status %; \
	/elseif ({1} =/ 'remove') \
		/remove_template %; \
	/else \
		/echo % TEMPLATE: '%{1}' is not a valid option. %; \
		/echo % TEMPLATE: Valid options are: enable disable status remove %; \
	/endif

;;;; All set, start it up
/set installed_template=1
/echo % TEMPLATE: installed
/enable_template
