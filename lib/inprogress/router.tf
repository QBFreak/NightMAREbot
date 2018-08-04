; Settings
/if ({router_groups} =/ '') \
	/set router_groups=%; \
/else \
	/echo % ROUTER: Warning, router_groups already set. I'm going to leave it alone. %; \
/endif

; Core commands
/def remword = \
	/if ($[getval({1})] =/ '') \
		/set %{1}=%; \
	/else \
		/set %{1} $[replace("  ", " ", replace(strcat(" ", {2}, " "), " ", strcat(" ", getval({1}), " ")))]%; \
	/endif
	
/def addword = \
	/if ($[getval({1})] =/ '') \
		/set %{1} %{2}%; \
	/else \
		/remword %{1} %{2} %; \
		/set %{1} $[getval({1})] %{2} %; \
	/endif

; Core functions
;  getval(varname) - returns the value of the variable
/def getval = /return "$(/eval /echo $[strcat("%", {1})])"
;  groupvar(groupname) - returns the variable for the group
/def groupvar = /return "$[strcat("group_", textencode({1}))]"
;  channelvar(world,channel) - returns the variable for world's channel
/def channelvar = /return "$[strcat("channel_", strcat(textencode({1}), "_", textencode({2})))]"
;  lastcommvar(groupname)
/def lastcommvar = /return "$[strcat("lastcomm_", textencode({1}))]"
;  members(groupname) - returns the members of groupname
/def members = /return "$[getval(groupvar({1}))]"
;  group(world,channel) - returns the group for world's channel
/def group = /return "$[getval(channelvar({1},{2}))]"
;  newcomm(groupname,text) - returns 0 if text is the same as the last sent to the group, 1 if its new
/def newcomm = \
	/if ({-1} =/ $[getval(lastcommvar({1}))]) \
		/return 0 %; \
	/else \
		/set $[lastcommvar({1})]=%{-1}%; \
		/return 1 %; \
	/endif

; Start out disabled so nothing happens while we're loading
/set router_enabled 0

;;; Router management
; Enable router command
/def enable_router = \
	/echo % ROUTER: Enabling channel routing %; \
	/set router_enabled 1

; Disable router command
/def disable_router = \
	/echo % ROUTER: Disabling channel routing %; \
	/set router_enabled = 0

; Remove all ROUTER code
/def remove_router = \
	/disable_router %; \
	/purge router_* %; \
	/purge *_router %; \
	/unset router_enable %; \
	/unset installed_router %; \
	/unset router_groups %; \
	/undef remword %; \
	/undef addword %; \
	/undef getval %; \
	/undef groupvar %; \
	/undef channelvar %; \
	/undef members %; \
	/undef group %; \
        /echo % ROUTER: removed

/def router_status = \
	/if ({router_enabled}) \
		/echo % ROUTER: Channel routing is enabled. %; \
	/else \
		/echo % ROUTER: Channel routing is disabled. %; \
	/endif

/def router_list = \
	/echo % ROUTER: the following groups exist: %{router_groups}

/def router_members = \
	/if ({1} =/ '') \
		/echo % ROUTER: usage: /router members <group>%; \
	/else \
		/echo % ROUTER: members of %{1}: $[members({1})]%; \
	/endif

/def router_group = \
	/if (({2} =/ '')|({1} =/ '')) \
		/echo % ROUTER: usage: /router group <world> <channel>%; \
	/else \
		/echo % ROUTER: group for %{1}'s %{2}: $[group({1}, {2})]%; \
	/endif


;;; Channel management
; channel_(world)_(channel) = group
; group_(group) = (world)_(channel) (world)_(channel) ...
; router_groups = (group) (group) ...

; Join group
/def router_join = \
	/if (({3} =/ '')|({2} =/ '')|({1} =/ '')) \
		/echo % ROUTER: usage: /router_join <world> <channel> <group>%; \
	/else \
		/set $[channelvar({1},{2})] %{3}%; \
		/addword $[groupvar({3})] $[strcat(textencode({1}),"_",textencode({2}))]%; \
		/addword router_groups $[textencode({3})]%; \
	/endif

; Leave group
/def router_leave = \
	/if (({3} =/ '')|({2} =/ '')|({1} =/ '')) \
		/echo % ROUTER: usage: /router_leave <world> <channel> <group>%; \
	/else \
; 		Remove the var that holds the channel's group
		/unset $[channelvar({1}, {2})] %; \
		/if ($[members({3})] =/ $[strcat(textencode({1}),"_",textencode({2}))]) \
;			The only member of the group is being removed, remove the group's var
			/unset $[groupvar({3})]%; \
;			Also remove the group's entry from the group list
			/remword router_groups $[textencode({3})]%; \
		/else \
;			Remove channel from the group
			/remword $[groupvar({3})] $[strcat(textencode({1}),"_",textencode({2}))]%; \
		/endif %; \
	/endif

; Process channel text
/def router_process = \
;	/if () \
;		/echo %; \
;	/else \
		/if ($[strlen(group({1}, {2}))]) \
			/if ($[newcomm(group({1}, {2}), {-2})]) \
				/echo % ROUTER: [$[group({1}, {2})]] %{-2} %; \
			/endif %; \
		/endif %; \
;	/endif

; Send channel text to all worlds except the sending world
/def router_groupsend = \
	


;;; Management command
/def router = \
	/if ({1} =/ '') \
		/echo % ROUTER: NightMAREbot router module, written by Jason Hill (qbfreak@qbfreak.net) %; \
		/echo % ROUTER: Provides channel groupings across worlds and relays messages between grouped channels. %; \
	/elseif ({1} =/ 'enable') \
		/enable_router %; \
	/elseif ({1} =/ 'disable') \
		/disable_router %; \
	/elseif ({1} =/ 'status') \
		/router_status %; \
	/elseif ({1} =/ 'remove') \
		/remove_router %; \
	/elseif ({1} =/ 'groups') \
		/router_list %; \
	/elseif ({1} =/ 'members') \
		/router_members %{-1} %; \
	/elseif ({1} =/ 'group') \
		/router_group %{-1} %; \
	/else \
		/echo % ROUTER: '%{1}' is not a valid option. %; \
		/echo % ROUTER: Valid options are: enable disable status remove groups members group%; \
	/endif
						

;;; All set, start it up
/if (!{installed_router}) \
	/set installed_router=1 %; \
	/echo % ROUTER: installed %; \
/endif

/enable_router
