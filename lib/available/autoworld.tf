;/def -p0 -h'ACTIVITY' activity_fg = /fg %1
/def -Fp0 -ag -E(awenable) -mglob -hACTIVITY  activity_hook = /fg %1

/def autoworld = \
	/if ({*} =/ 'on') \
		/autoworld_on %; \
	/elseif ({*} =/ 'off')  \
		/autoworld_off %; \
	/elseif ({*} =/ 'status')  \
		/autoworld_status %; \
	/elseif ({*} =/ 'kill') \
		/autoworld_kill %; \
	/else \
		/echo % AUTOWORLD: invalid option "%*". %; \
		/echo % AUTOWORLD: valid options are: on off kill status %; \
	/endif

/def autoworld_on = \
	/echo % AUTOWORLD: enabled %; \
	/set awenable 1 %;

/def autoworld_off = \
	/echo % AUTOWORLD: disabled %; \
	/set awenable 0 %; 

/def remove_autoworld = \
	/undef activity_hook %; \
	/unset awenable %; \
	/unset installed_autoworld %; \
	/purge autoworld* %; \
	/undef remove_autoworld

/def autoworld_status = \
	/echo % AUTOWORLD: enabled: %{awenable}

/set installed_autoworld=1
/echo % AUTOWORLD: installed
/autoworld_on
