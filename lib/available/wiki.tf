;;; wiki.tf - Expand wiki links seen in channels
;;;  QBFreak <qbfreak@qbfreak.net> 5/20/2017

; P1=Channel    P2=Sender       P3=Wiki         P4=Page
/def -Fp1 -E'{wiki_enable}' -mregexp -t'^\[([^ ]+)\] ([^ :]+).* ([^ :]+):([^ ]+)' wiki_trigger = \
    /send -w$[world_info()] WIKILINK %P1 %P3 %P4 %; \
    /set gag_title=1

/def wiki = \
	/if (%1 =~ "") \
		/wiki_status %; \
	/elseif (%1 =~ "status") \
		/wiki_status %; \
	/elseif (%1 =~ "enable") \
		/wiki_enable %; \
	/elseif (%1 =~ "disable") \
		/set wiki_enable=0%; \
		/echo % Wiki disabled.%; \
	/elseif (%1 =~ "remove") \
		/unset wiki_enable %; \
		/purge wiki_* %; \
		/undef wiki %; \
		/echo % Wiki removed. %; \
	/endif

/def wiki_enable = \
	/set wiki_enable=1%; \
	/echo % Wiki enabled.

/def wiki_status = \
	/if (%wiki_enable) \
		/echo % Wiki is enabled %; \
	/else \
		/echo % Wiki is disabled %; \
	/endif %; \

/wiki_enable
