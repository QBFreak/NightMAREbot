; Settings
/set irc_info mare.qbfreak.net
/set irc_nickserv NICKSERV

; Start out disabled so nothing happens while we're loading
/set irc_enabled 0
/set irc_autojoin 0


;;; IRC code management
; Enable irc command
/def enable_irc = \
	/echo % IRC: Enabling IRC %; \
	/set irc_enabled 1 %; \
	/quote -S /connect !"sbin/enabled_worlds.pl IRC"

; Disable irc command
/def disable_irc = \
	/echo % IRC: Disabling IRC %; \
	/set irc_enabled 0 %; \
	/quote -S /send -w!"sbin/enabled_worlds.pl IRC" QUIT I've been disabled.

; Remove all IRC code
/def remove_irc = \
	/disable_irc %; \
;	/purgeworld -TIRC %; \
	/unset irc_info %; \
	/unset irc_nickserv %; \
	/unset irc_enabled %; \
	/unset irc_autojoin %; \
	/unset installed_irc %; \
	/undef msg %; \
	/undef join %; \
	/undef part %; \
	/undef irc %; \
	/purge irc_* %; \
	/purge *_irc %; \
        /echo % IRC: removed

; IRC status
/def irc_status = \
	/if ({irc_enabled}) \
		/echo % IRC: IRC module is enabled. %; \
	/else \
		/echo % IRC: IRC module is disabled. %; \
	/endif

; View/set irc_info
/def irc_info = \
	/if ({1} =/ '') \
		/echo % IRC: info: %{irc_info} %; \
	/else \
		/set irc_info %{*} %; \
		/echo % IRC: info set to '%{irc_info}' %; \
	/endif %; \

; Vew/set irc_nickserv (nickserv command)
/def irc_manage_nickserv = \
	/if ({1} =/ '') \
		/echo % IRC: nickserv command: %{irc_nickserv} %; \
	/else \
		/set irc_nickserv %{*} %; \
		/echo % IRC: nickserv command set to '%{irc_nickserv}' %; \
	/endif %; \

; Vew/set autojoin status
/def irc_manage_autojoin = \
	/if (({1} =/ '') | ({1} =/ 'status')) \
		/if ({irc_autojoin}) \
			/echo % IRC: Autojoin is enabled. %; \
		/else \
			/echo % IRC: Autojoin is disabled. %; \
		/endif %; \
	/elseif (({1} =/ 'enable') | ({1} =/ '1') | ({1} =/ 'on')) \
		/set irc_autojoin 1 %; \
		/echo % IRC: Autojoin enabled. %; \
	/elseif (({1} =/ 'disable') | ({1} =/ '0') | ({1} =/ 'off')) \
		/set irc_autojoin 0 %; \
		/echo % IRC: Autojoin disabled. %; \
	/else \
		/echo % IRC: Invalid autojoin option. %; \
		/echo % IRC: Valid options are: status enable on 1 disable off 0 %; \
	/endif %; \


;;; Core code
; Connect hook for IRC - sets user, nick, and then identifies with nickserv
/def -E{irc_enabled} -TIRC -p1 -ag -hCONNECT irc_connect = \
	/send USER $[world_info("character")] %{irc_info} %{irc_info} $[world_info("character")] %; \
	/send NICK $[world_info("character")] %{irc_info} %; \
	/irc_identify %; \
	/echo % IRC: Connected to $[world_info()] as $[world_info("character")]

; Pink/pong trigger
/def -Fp1 -ag -mregexp -T'IRC' -E'{irc_enabled}' -t'^PING :(.*)' irc_ping = /send PONG %{P1}

; Common Aliases
/def msg = /send PRIVMSG %{1} :%{-1}
/def notice = /send NOTICE %{1} :%{-1}
/def join = /send JOIN %{1}
/def part = /send PART %{1}

; NickServ commands
/def irc_nickserv = /send %{irc_nickserv} :%{*}
/def irc_identify = /irc_nickserv IDENTIFY $[world_info("password")]


;;; Autojoin
; Auto-join trigger
/def -Fp1 -mregexp -T'IRC' -E'({irc_enabled}&{irc_autojoin})' -t'^:([^!]+)!([^ ]+) INVITE ([^ ]+) :(.*)$' irc_autojoin = \
	/if ({P3} =/ $[world_info("character")]) \
		/send JOIN %{P4} %; \
	/endif


;;; Management command
/def irc = \
	/if ({1} =/ '') \
		/echo % IRC: NightMAREbot IRC module, written by Jason Hill (qbfreak@qbfreak.net) %; \
		/echo % IRC: Provides basic commands and triggers to connect to IRC servers. %; \
	/elseif ({1} =/ 'enable') \
		/enable_irc %; \
	/elseif ({1} =/ 'disable') \
		/disable_irc %; \
	/elseif ({1} =/ 'status') \
		/irc_status %; \
	/elseif ({1} =/ 'remove') \
		/remove_irc %; \
	/elseif ({1} =/ 'identify') \
		/irc_identify %; \
	/elseif ({1} =/ 'info') \
		/irc_info %{-1} %; \
	/elseif ({1} =/ 'nickserv') \
		/irc_manage_nickserv %{-1} %; \
	/elseif ({1} =/ 'autojoin') \
		/irc_manage_autojoin %{-1} %; \
	/else \
		/echo % IRC: '%{1}' is not a valid option. %; \
		/echo % IRC: Valid options are: enable disable status remove identify info nickserv autojoin%; \
	/endif

;;;; All set, start it up
/set installed_irc=1
/echo % IRC: installed
/enable_irc
