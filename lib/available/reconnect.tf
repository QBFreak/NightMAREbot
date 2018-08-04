;;; reconnect.tf - Automatically reconnect to disconnected TinyFugue worlds
;;;  QBFreak <qbfreak@qbfreak.net> 4/29/2017

/def -Fp1 -ag -E'!{intentional_disconnect} & {autoreconnect_enable}' -hDISCONNECT autoreconnect_hook = /connect %1
/def -Fp1 -ag -E'{intentional_disconnect} & {autoreconnect_enable}' -hDISCONNECT reset_autoreconnect = /set intentional_disconnect=0
/def -Fp1 -E'{autoreconnect_enable}' -mregexp -h'SEND ^QUIT$' quithook = /set intentional_disconnect=1

/def cc = /connect $[world_info()]

/def autoreconnect = \
	/if (%1 =~ "") \
		/autoreconnect_status %; \
	/elseif (%1 =~ "status") \
		/autoreconnect_status %; \
	/elseif (%1 =~ "enable") \
		/autoreconnect_enable %; \
	/elseif (%1 =~ "disable") \
		/set autoreconnect_enable=0%; \
		/echo % Auto Reconnect disabled.%; \
	/elseif (%1 =~ "remove") \
		/unset autoreconnect_enable %; \
		/unset intentional_disconnect %; \
		/undef autoreconnect_hook %; \
		/undef reset_autoreconnect %; \
		/undef quithook %; \
		/undef autoreconnect_enable %; \
		/undef autoreconnect_status %; \
		/undef autoreconnect %; \
		/undef cc %; \
		/echo % Auto Reconnect removed. %; \
	/endif

/def autoreconnect_enable = \
	/set autoreconnect_enable=1%; \
	/echo % Auto Reconnect enabled.

/def autoreconnect_status = \
	/if (%autoreconnect_enable) \
		/echo % Auto Reconnect is enabled %; \
	/else \
		/echo % Auto Reconnect is disabled %; \
	/endif %; \

/autoreconnect_enable
