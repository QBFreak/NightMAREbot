/loaded intermare.tf
/require -q lisp.tf

;; Test to iterate over a list of words
; /wlist <list>
; Not sure why I couldn't just use /mapcar say <list>
/def wlist = \
	/let i=%* %; \
	/while /test ($(/length %i) > 0) %; \
		/do \
			say $(/first %i) %; \
			/let i=$(/rest %i) %; \
		/done
	
/def broadcast = \
	/if ({lastinter} !~ {*}) \
		/let bcworlds_intermare=$(/remove ${world_name} %{worlds_intermare}) %; \
		/while /test ($(/length %{bcworlds_intermare}) > 0) %; /do \
			/echo /send -w$(/car %{bcworlds_intermare}) intermare $[encode_attr(%{*})] %; \
			/let bcworlds_intermare=$(/cdr %{bcworlds_intermare}) %; \
		/done %; \
	/endif %; \
	/set lastinter=%{*}
			
/def -Fp1 -E'{enabled_intermare}' -T'diku' -mregexp -t'^\\[intermare\\] .*' trigger_intermare = /broadcast $(/rest %*)

/def list_intermare = \
    /echo % Intermare Operating on the following worlds: %{worlds_intermare}

/def rebuild_intermare = \
    /quote -S /set worlds_intermare=!"sbin/enabled_worlds.pl -n diku"

/def remove_intermare = \
	/undef trigger_intermare %; \
	/undef wlist %; \
	/undef broadcast %; \
	/unset lastinter %; \
        /undef intermare %; \
        /purge *_intermare %; \
        /unset enabled_intermare %; \
	/unset worlds_intermare %; \
	/unset installed_intermare %; \
	/echo % Intermare removed

/def intermare = \
    /if (%1 =~ "") \
        /status_intermare %; \
    /elseif (%1 =~ "status") \
        /status_intermare %; \
    /elseif (%1 =~ "list") \
        /list_intermare %; \
    /elseif (%1 =~ "enable") \
        /enable_intermare %; \
    /elseif (%1 =~ "disable") \
        /set enabled_intermare=0 %; \
        /echo % Intermare disabled. %; \
    /elseif (%1 =~ "remove") \
        /remove_intermare %; \
    /elseif (%1 =~ "rebuild") \
        /rebuild_intermare %; \
    /elseif (%1 =~ "help") \
        /usage_intermare %; \
    /else \
        /echo % Intermare: Unknown command %; \
        /usage_intermare %; \
    /endif

/def status_intermare = \
    /if (%enabled_intermare) \
        /echo % Intermare is enabled %; \
    /else \
        /echo % Intermare is disabled %; \
    /endif

/def enable_intermare = \
    /set enabled_intermare=1 %; \
    /echo % Intermare enabled.

/def usage_intermare = \
    /echo % Intermare usage: /intermare [status | list | enable | disable | remove | rebuild | help]

/rebuild_intermare
/set installed_intermare=1
/echo % Intermare installed
/enable_intermare
/list_intermare

