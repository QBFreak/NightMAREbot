;;; the attributes to put before the fg, bg (no activity), or bg (has activity) world names
;/set tablist_fg_world_attrs=@{Cwhite,Cbgrgb001}
/set tablist_fg_world_attrs=@{hCwhite,Cbgrgb001}
/set tablist_bgworld_attrs=@{Ccyan,Cbgrgb001}
/set tablist_bgmore_world_attrs=@{Cbrightred,Cbgrgb001}
/set tablist_tab_attrs=@{Crgb034,Cbgrgb001}
;;; seperator between tabs within a world. 
;;;   - note: changing this and the next pair could well break certain aspects
;;;           of the tabs screen fitting part (I'll fix eventually)
/set tablist_tab_sep=@{Cgray}|
;;; seperators between entire worlds.
/set tablist_world_sep_l=@{Cgray,Cbgrgb001}[
/set tablist_world_sep_r=@{Cgray}]
;;; Left and Right side of "more" numbers
/set tablist_more_l=:
/set tablist_more_r=
;;; left and right side of "much more" MM tag.
/set tablist_muchmore_l=:
/set tablist_muchmore_r=
;;; what to prepend to a dead (ie: !is_open()) world
/set tablist_deadworld=!
;;; do we want to show number of lines of activity?
/set tablist_show_lines=1
;;; do we want the entire world tab set to collapse to just the world name 
;;; when it's not active?
/set tablist_collapse_world=1
;;; should collapsed tabs with activity expand even if the world isn't active?
/set tablist_collapse_show_active=1

/def get_tablist_size=\
	/if (regmatch("tabs:([^:]*):", status_fields)) \
		/return %P1 %;\
	/else \
		/return columns() %;\
	/endif

/def build_tabs=\
;	Tweaked for QBFreak's sorted tab extensions 4/28/2017
;	 changed the value of _slist from the list of connected sockets, to a list of connected sockets in the order the user has specified
;	/let _slist=$(/@listsockets -s -mregexp ^[^:]+\$) %;\
	/let _slist=$(/sortedsockets) %; \
	/let _w=$(/first %_slist) %;\
	/test _ret:="" %;\
	/while ( _w !~ "" ) \
		/test _ret := strcat(_ret, tablist_world_sep_l)%;\
		/let _tlist=$(/@listsockets -s -mregexp ^%_w:) %;\
		/test _tlist := strcat(_w, " ", _tlist)%;\
		/let _t=$(/first %_slist) %;\
		/while ( _t !~ "" ) \
			/test _ret_item:="" %;\
			/test _new := moresize("", _t) %;\
			/if (_t !~ tab_world(_t)) \
				/test _ret_item := strcat(_ret_item, tablist_tab_sep) %;\
			/endif %;\
			/if (_t =~ fg_world()) \
				/test _ret_item := strcat(_ret_item, tablist_fg_world_attrs )%;\
			/elseif (_new > 0) \
				/test _ret_item := strcat(_ret_item, tablist_bgmore_world_attrs )%;\
			/elseif (_t !~ tab_world(_t)) \
				/test _ret_item := strcat(_ret_item, tablist_tab_attrs )%;\
			/else \
				/test _ret_item := strcat(_ret_item, tablist_bgworld_attrs )%;\
			/endif %;\
			/if (!is_open(_t)) /test _ret_item := strcat(_ret_item,tablist_deadworld) %; /endif %;\
			/test _ret_item := strcat(_ret_item, substr(_t, strchr(_t,":") > -1 ? strchr(_t,":")+1 : 0)) %;\
			/test _mt := ""%;\
			/if (_new > 0 & _new < 1000 & tablist_show_lines) \
				/test _mt := strcat(tablist_more_l, _new, tablist_more_r) %;\
			/elseif (_new > 1000 & tablist_show_lines) \
				/test _mt := strcat(tablist_muchmore_l, "MM", tablist_muchmore_r) %;\
			/endif %;\
			/test _ret_item := strcat(_ret_item, _mt) %;\
			/if (!(tablist_collapse_world & tab_world(_t) !~ tab_world(fg_world()) & (_new = 0 | (_new > 0 & !tablist_collapse_show_active)))) \
				/test _ret := strcat(_ret, _ret_item) %;\
			/elseif (_t =~ tab_world(_t)) \
				/test _ret := strcat(_ret, _ret_item) %;\
			/endif %;\
			/let _tlist=$(/rest %_tlist) %;\
			/let _t=$(/first %_tlist) %;\
		/done %;\
		/test _ret := strcat(_ret, tablist_world_sep_r ) %;\
		/let _slist=$(/rest %_slist) %;\
		/let _w=$(/first %_slist) %;\
	/done %;\
	/test _dret:=decode_attr(_ret) %;\
	/test _avail_len:=get_tablist_size() %;\
	/if (strlen(_dret) > _avail_len) \
		/if (is_tab(fg_world())) \
			/test _fg_loc:=strstr(_dret, tab_name(fg_world())) %;\
		/else \
			/test _fg_loc:=strstr(_dret, fg_world()) %;\
		/endif %;\
		/test _cutoff:=strchr(_dret, "|[", _fg_loc - _avail_len/2 > 0 ? _fg_loc - _avail_len/2 : 0) %;\
	/else \
		/test _cutoff:=0 %;\
	/endif %;\
	/return tolower(substr({_dret}, _cutoff))

/set status_var_tabs=build_tabs()


;;; QBFreak's tab extensions - 3/1/2006 - qbfrea@qbfreak.net
/status_rm @world
/status_rm @more
/status_rm @active
/status_add -B tabs
/def -Fp1 -hACTIVITY|BGTEXT|MORE|WORLD update_status = /status_edit tabs
/def -p0 -aAg -hPREACTIVITY|ACTIVITY|BGTEXT|MORE|WORLD|CONNECT ignore_alerts

;;; QBFreak's sorted tab extensions - 4/28/2017 - qbfreak@qbfreak.net
;;; Whoo! Now you can specify the order the worlds appear!
;;;  use /set worldorder=Worldname1 Worldname2 Worldname3
;;;  disconnected worlds are still excluded from the list
;;;  if you specify some worlds but not all, the missing worlds will be appended to the end in the order the sockets were connected
;;;  if worldorder is blank, it will fall back to the list of connected sockets (the old way)
/def sortedsockets = \
        /if (%1 =~ "-a") \
                /let _inval=$(/listsockets -s) %; \
        /else \
                /let _inval=$(/@listsockets -s -mregexp ^[^:]+\$) %; \
        /endif %; \
        /if (worldorder =~ "") \
                /result "%_inval" %; \
        /endif %; \
        /let _unsortedsockets=%_inval %; \
        /let _sorder=%worldorder %; \
        /let _unspecifiedsockets=%_unsortedsockets %; \
        /let _os=$(/first %worldorder) %; \
        /while (_os !~ "") \
                /let _unsort=%_unspecifiedsockets %; \
                /let _unspecifiedsockets=%; \
                /let _us=$(/first %_unsort)%; \
                /while (_us !~ "") \
                        /if (%_os =~ %_us) \
                                /let _retval=%_retval %_us %; \
                        /else \
                                /let _unspecifiedsockets=%_unspecifiedsockets %_us %; \
                        /endif %; \
                        /let _unsort=$(/rest %_unsort) %; \
                        /let _us=$(/first %_unsort) %; \
                /done %; \
                /let _sorder=$(/rest %_sorder) %; \
                /let _os=$(/first %_sorder) %; \
        /done %; \
;       Using /echo strips the leading space from variable values
        /let _retval=%_retval $(/echo %_unspecifiedsockets) %; \
        /result "$(/echo %_retval)"

