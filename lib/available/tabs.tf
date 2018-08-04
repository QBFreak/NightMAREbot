;;;
;;; Heller's (heller@wacked.org)  modified tabs. 
;;; Taken unashamedly from draco's excellent work, with help from Andy.
;;;
;;; Implements a virtual multi world system allowing users to split their
;;; the output of their worlds into multiple "tabs". On our moo we use it to
;;; split things like "+com channels", Jabber IM output, and RSS feed output
;;; to other tabs to keep our main communication window free from SPAM.
;;;
;;; The current development version is always available here:
;;; http://www.wacked.org:8888/~heller/tabs.tf
;;; That's symlinked to the one I'm "working" on. 

;;; change this to reflect your setup:
/loaded ~/tf/tabs.tf

;; general debugging flag. used in sendtotab right now. 
/set debug_tabs=0

;;; creates a new tab 
;;; sets a hook 
/def newtab=\
;	/if (world_info({1}, "name") =~ "") /return %; /endif %;\
	/addworld -Ttab -e %1 %;\
	/eval /def -p999 -w%1 -agG -h'DISCONNECT' -q world_disc_$[textencode({1})]=\
		/sendtotab %1 --- Main World $[tab_world({1})] disconnected ---

/def is_tab=\
     /if (world_info({1}, "type") =~ "tab") \
     	/return 1%; \
     /else \
        /return 0%; \
     /endif

;;; returns the base world name (stuff before the :)
/def tab_world=\
	/if (is_tab({1})) \
		/return substr({1}, 0, strchr({1},":")) %;\
	/else \
        	/return {1} %;\
	/endif

;;; returns the name of the tab (stuff after the :)
/def tab_name=\
	/if (is_tab({1})) \
		/return substr({1}, strchr({1},":")+1) %;\
	/else \
        	/return "" %;\
	/endif

;;; sendtotab command (not function). now it passes along options to /echo 
;;; and will trigger triggers in the target world. Eventually, additional
;;; will most assuredly be created. 
/def sendtotab= \
	/if ( {debug_tabs} == 1 ) /echo 1: %{*} %; /endif %;\
	/let opt_a=%; /let opt_p=0%; \
	/if (!getopts("a:p")) /return 0%; /endif%; \
	/if (world_info({1}, "name") =~ "") /newtab %{1}%; /endif %; \
	/if (is_open({1}) == 0) /connect -b %1%; /endif %; \
	/if (!is_tab({1})) /return 0%; /endif %; \
	/if /!trigger -w%1 %{-1} %; /then \
		/return echo({-1}, opt_a, !!opt_p, "w%1") %;\
	/endif

;;; enables #$# TAB <world_name> <text> to trigger automatic new tabs
/def -agG -q -mregexp -t"^#\$# TAB ([^ ]*) " tabbed_world1=/sendtotab $[strcat(world_info(), ":", {P1})] %{PR}

;;; send all commands to the "base world" 
/def -p1000 -Ttab -mregexp -h'SEND' tabredirect=/test send({*}, tab_world(world_info()))


;;;
;;; Contributed by Andy. 
;;; 


;;; in tf5, alt-left & alt-right switch worlds.
;;; this adds alt-up and alt-down for switching tabs within a world. 

/def nexttabafter=/let fullname=%1%;\
	/let socketlist=%2 %2%; \
	/let worldname=$[tab_world(fullname)]%; \
	/while ($(/first %socketlist) !~ fullname) \
		/let socketlist=$(/rest %socketlist)%; \
	/done%; \
	/let socketlist=$(/rest %socketlist)%; \
	/while (tab_world($(/first %socketlist)) !~ worldname) \
		/let socketlist=$(/rest %socketlist)%; \
	/done%;\
	/return $$(/first %socketlist)

;; /return "$[escape("\\\"", $(/first %socketlist))]"
;; fix " for vim syntax hilighting - mhh

;       Tweaked for QBFreak's sorted tab extensions 4/28/2017
;        changed the value from the list of connected sockets, to a list of connected sockets in the order the user has specified
;/def nexttab=/fg $[nexttabafter(world_info(), $(/listsockets -s))]
/def nexttab=/fg $[nexttabafter(world_info(), $(/sortedsockets -a))]

;/def prevtab=/let tmpsocketlist=$(/listsockets -s)%;\
/def prevtab=/let tmpsocketlist=$(/sortedsockets -a)%;\
	/let socketlist=%; \
	/while (strlen(tmpsocketlist)) \
		/let socketlist=$(/first %tmpsocketlist) %socketlist%; \
		/let tmpsocketlist=$(/rest %tmpsocketlist)%; \
	/done%; \
	/fg $[nexttabafter(world_info(), socketlist)]

/def key_esc_down=/nexttab
/def key_esc_up=/prevtab

;;; in tf5, alt-left & alt-right switch worlds.
;;; this modifies these keys to actually switch worlds, not tabs
;;; it will go to an arbitrary tab within the first "different" world it
;;; finds in either direction

; didnt end up needing this, keep it around just in case
;	/while ((tab_world($(/first %socketlist)) =~ worldname | is_tab($(/first %socketlist))) & ($(/first %socketlist) !~ fullname) & (strlen(socketlist) !~ 0)) \

/def nextworldafter=/let fullname=%1%;\
	/let socketlist=%2 %2%; \
	/let worldname=$[tab_world(fullname)]%; \
	/while ($(/first %socketlist) !~ fullname) \
		/let socketlist=$(/rest %socketlist)%; \
	/done%; \
	/let socketlist=$(/rest %socketlist)%; \
	/while (is_tab($(/first %socketlist)) | tab_world($(/first %socketlist)) =~ worldname ) \
		/let socketlist=$(/rest %socketlist)%; \
	/done%;\
	/return "$[escape("\\\"", $(/first %socketlist))]"

;; fix " for vim syntax hilighting - mhh

;       Tweaked for QBFreak's sorted tab extensions 4/28/2017
;        changed the value from the list of connected sockets, to a list of connected sockets in the order the user has specified
;/def nextworld=/fg $[nextworldafter(world_info(), $(/listsockets -s))]
/def nextworld=/fg $[nextworldafter(world_info(), $(/sortedsockets -a))]

;/def prevworld=/let tmpsocketlist=$(/listsockets -s)%;\
/def prevworld=/let tmpsocketlist=$(/sortedsockets -a)%;\
	/let socketlist=%; \
	/while (strlen(tmpsocketlist)) \
		/let socketlist=$(/first %tmpsocketlist) %socketlist%; \
		/let tmpsocketlist=$(/rest %tmpsocketlist)%; \
	/done%; \
	/fg $[nextworldafter(world_info(), socketlist)]

/def key_esc_right=/nextworld
/def key_esc_left=/prevworld

;;;  
;;; The effect is that when you type a command from a tab, the output gets 
;;; redirected back to that tab automatically. The downside is... if the 
;;; MOO task suspends, you only get the output up until the first suspend.
;;;
;;; mhh: It's currently commented out because of the downside. If you decide
;;; this is an acceptable risk, go ahead and uncomment each line below.
;;; and really, it is, but I don't want people complaining to me it's broken.

;/def -p1000 -Ttab -mregexp -h'SEND' tabredirect=/test sendcmdfromtab(world_info(), {*})
;/def -p1000 -Ttab -mregexp -h'SEND ^;' tabredirect-eval=/test sendcmdfromtab(world_info(), {*})
;
;/def sendcmdfromtab=/let world=$[tab_world({1})]%; \
;	/let tab=$[tab_name({1})]%; \
;	/test send(strcat("PREFIX #\$# TABBEGIN ", tab), world)%; \
;	/test send(strcat("SUFFIX #\$# TABEND ", tab), world)%; \
;	/test send({2}, world)%; \
;       /test send("PREFIX", world)%; \
;	/test send("SUFFIX", world)
;
;/def -p1000 -agG -q -mregexp -t'^#\$# TABBEGIN ' ttabbegin=\
;	/let tabname=%{PR}%; \
;	/eval /def -p999 -w -mregexp -t'^' -agG -q \
;		tgraballfortab_$[textencode(world_info())]=\
;		/test sendtotab(strcat(world_info(), ":", "$[escape("\\\"", tabname)]"), {PR})
;
;;;;; again. fix " for syntax hiliting -- mhh
;
;/def -p1000 -agG -q -mregexp -t'^#\$# TABEND ' ttabend=/undef tgraballfortab_$[textencode(world_info())]


;;; QBFreak's tab extensions - 3/1/2006 - qbfreak@qbfreak.net
/def create_channel_tab = \
	/let cct1 %{1}%; \
	/let cct2 %{2}%; \
	/newtab %{cct1}:%{cct2} %; \
	/def -Fp1 -ag -mregexp -t'^\\[%{cct2}\\] .*' -E'{tab_%{cct1}_%{cct2}_enabled}' -w%{cct1} tab_%{cct1}_%{cct2} = \
	 	/sendtotab %{cct1}:%{cct2} $[strcat("%","{","*}")] %; \
	/echo % TABS: Redirecting channel %{cct2} to world %{cct1}:%{cct2} %; \
	/connect -b %{cct1}:%{cct2} %; \
	/set tab_%{cct1}_%{cct2}_enabled 1

/def enable_tab = \
	/set tab_%{1}_%{2}_enabled 1%; \
	/echo % TABS: Redirect for %{1}'s %{2} enabled

/def disable_tab = \
	/set tab_%{1}_%{2}_enabled 0%; \
	/echo % TABS: Redirect for %{1}'s %{2} disabled

/def create_group_tab = \
	/newtab %{1}:%{2} %; \
	/connect -b %{1}:%{2} %; \
	/enable_tab %{1} %{2}

; /def_tab_trigger <world> <group> <name> '<regex>'
/def def_tab_trigger = \
	/def -Fp1 -ag -mregexp -t'%{-3}' -E'{tab_%{1}_%{2}_enabled}' -w%{1} tab_%{1}_%{3} = \
	 	/sendtotab %{1}:%{2} $[strcat("%","{","*}")] %; \

; /def_tab_channel_trigger <world> <channel> <group>
/def def_tab_channel_trigger = \
	/def_tab_trigger %{1} %{3} %{2}_%{3} ^\\[%{2}\\] .*

/def redir_enabled = \
	/result "$(/eval /echo $[strcat("%","{tab_",{1},"_",{2},"_enabled}")])"

/def redir = \
	/if ({1} !/ '') \
		/if ({2} =/ '') \
			/let redir_world=$[world_info()]%; \
			/let redir_channel=%{1}%; \
		/else \
			/let redir_world=%{1}%; \
			/let redir_channel=%{2}%; \
		/endif %; \
		/if (redir_enabled({redir_world},{redir_channel}) =/ '') \
			/create_channel_tab %{redir_world} %{redir_channel} %; \
		/elseif (redir_enabled({redir_world},{redir_channel}) =/ '0') \
			/set tab_%{redir_world}_%{redir_channel}_enabled 1%; \
			/echo % TABS: Redirect for %{redir_world}'s channel %{redir_channel} enabled %; \
		/else \
			/echo % TABS: Redirect for %{redir_world}'s channel %{redir_channel} already enabled %; \
		/endif %; \
	/else \
		/echo % TABS: /redir - Redirect a channel to its own world %; \
		/echo % TABS: Invalid number of parameters %; \
		/echo % TABS: Usage: /redir <world> <channel> %; \
		/echo % TABS:        /redir <channel> %; \
	/endif

; /redir_chan [world] channel group
/def redir_chan = \
	/if (({1} !/ '') & ({2} !/ '')) \
		/if ({3} =/ '') \
			/let redir_world=$[world_info()]%; \
			/let redir_channel=%{1}%; \
			/let redir_group=%{2}%; \
		/else \
			/let redir_world=%{1}%; \
			/let redir_channel=%{2}%; \
			/let redir_group=%{3}%; \
		/endif %; \
		/if (redir_enabled({redir_world},{redir_group}) =/ '') \
			/create_group_tab %{redir_world} %{redir_group} %; \
		/elseif (redir_enabled({redir_world},{redir_group}) =/ '0') \
			/enable_tab %{redir_world} %{redir_group} %; \
		/else \
			/echo % TABS: Adding %{redir_channel} to %{redir_world}'s %{redir_group} %; \
		/endif %; \
		/def_tab_channel_trigger %{redir_world} %{redir_channel} %{redir_group}%; \
	/else \
		/echo % TABS: /redir - Redirect a channel to its own world %; \
		/echo % TABS: Invalid number of parameters %; \
		/echo % TABS: Usage: /redir <world> <channel> %; \
		/echo % TABS:        /redir <channel> %; \
	/endif
	

/def reset = \
	/if ({1} !/ '') \
		/if ({2} =/ '') \
			/let redir_world=$[world_info()]%; \
			/let redir_channel=%{1}%; \
		/else \
			/let redir_world=%{1}%; \
			/let redir_channel=%{2}%; \
		/endif %; \
		/if (redir_enabled({redir_world},{redir_channel}) =/ '') \
			/echo % TABS: %{redir_world}'s %{redir_channel} is not being redirected %; \
		/elseif (redir_enabled({redir_world},{redir_channel}) =/ '0') \
			/echo % TABS: Redirect for %{redir_world}'s channel %{redir_channel} already disabled %; \
		/else \
			/set tab_%{redir_world}_%{redir_channel}_enabled 0%; \
			/echo % TABS: Redirect for %{redir_world}'s channel %{redir_channel} disabled %; \
		/endif %; \
	/else \
		/echo % TABS: /reset - Disable a channel redirect %; \
		/echo % TABS: Invalid number of parameters %; \
		/echo % TABS: Usage: /reset <world> <channel> %; \
		/echo % TABS:        /reset <channel> %; \
	/endif

/def unredir = \
	/if ({1} !/ '') \
		/if ({2} =/ '') \
			/let redir_world=$[world_info()]%; \
			/let redir_channel=%{1}%; \
		/else \
			/let redir_world=%{1}%; \
			/let redir_channel=%{2}%; \
		/endif %; \
		/unset tab_%{redir_world}_%{redir_channel}_enabled %; \
		/undef tab_%{redir_world}_%{redir_channel} %; \
		/undef world_disc_$[textencode(strcat({redir_world},":",{redir_channel}))] %; \
		/echo % TABS: Everything has been removed except the actual world. You will need to disconnect and '/unworld %{redir_world}:%{redir_channel}' yourself. %; \
	/else \
		/echo % TABS: /unredir - Remove a channel redirect and the matching world%; \
		/echo % TABS: Invalid number of parameters %; \
		/echo % TABS: Usage: /unredir <world> <channel> %; \
		/echo % TABS:        /unredir <channel> %; \
	/endif
	
