;; so we can /load .tf files without specifying the path
/set TFPATH=%TFLIBDIR ~/lib/enabled

;; Handy commands
/def redraw_status = /set status_fields=%{status_fields}

;; Keep-alive gagging
/def -Fp0 -agL -mglob -t'@@-IGNORE-@@' common_ignore = /echo -ag nop
/def -Fp0 -agL -mregexp -t'^\\[keepalive\\] .*' common_keepalive = /echo -ag nop
/def -Fp0 -agL -mregexp -t'^\\[timestamp\\] .*' common_timestamp = /echo -ag nop

;; Keep the Database Checkpoints from triggering ACTIVITY
/def -F -aA -q -t"\[_log_main\] Database Checkpointing: {*}" noact_dbcheckpoint
/def -F -aA -q -t"\[_log_main\] {*} Checkpoint Done. Filesize: {*} bytes" noact_checkpointdone

;; There's been a rash of 'GET /' requests, so lets start muting activity for them as well
/def -F -aA -q -t"\[_log_io\] Failed connect {*} GET / HTTP/1.1 from {*}" noact_getroot
; Unfortunately this means ignoring all Login and Logout on [_log_io]
/def -F -aA -q -mregexp -t"\[_log_io\] Login [0-9]+: .*\. desc->[0-9]+" noact_login
/def -F -aA -q -mregexp -t"\[_log_io\] Logout [0-9]+: .*\. desc->[0-9]+" noact_logout

;; QBFreak has a client on his phone that connects as an alt-character, but it reconnects a lot. Ignore it too
/def -F -aA -q -mregexp -t"\[_log_io\] Session [0-9]+: Unknown terminal type 'blowtorch'." noact_blowtorch
/def -F -aA -q -mregexp -t"\[_log_io\] Connect [0-9]+: JayNye\(#19473\)\. desc->[0-9]+" noact_logio_connect_jaynye
/def -F -aA -q -t"Connect: JayNye" noact_connect_jaynye
/def -F -aA -q -mregexp -t"\[_log_io\] Reconnect [0-9]+: JayNye\(#19473\)\. desc->[0-9]+" noact_logio_reconnect_jaynye
/def -F -aA -q -t"Reconnect: JayNye" noact_reconnect_jaynye
/def -F -aA -q -mregexp -t"\[_log_io\] Disconnect [0-9]+: JayNye\(#19473\)\. desc->[0-9]+" noact_logio_disconnect_jaynye
/def -F -aA -q -t"Disconnect: JayNye" noact_disconnect_jaynye

;; Keep the various SluggyMARE @asunset, @asunrise messages from triggering ACTIVITY
/def -aA -q -t"As the last rays of the setting sun vanish beneath the horizon, shadows appear throughout the land as its long lasting peace turns to the evil, cursed realm of darkness." noact_sunset
/def -aA -q -t"\[public\] Harena poings off into the ooo-shiny sunset!!" noact_asunset_harena
/def -aA -q -t"Please don't LART me!\> QBFreak - Triggered." noact_asunset_pleasedontlart
/def -aA -q -t"\[public\] QBFreak blends into the shadows" noact_asunset_qbfreak
/def -aA -q -t"\[public\] Serif comes back out of hiding now that the asunset crowd has passed." noact_asunset_serif
/def -aA -q -t"After a terribly long night, the spirits fade as the tranquil light of the eastern sun shines over the horizon and once again fills the land with peace." noact_sunrise
/def -aA -q -t"\[public] QBFreak screams in pain \"It burrnnss!\"" noact_asunrise_qbfreak

;; Hooks
/def -p0 -F -mglob -h'CONFAIL' common_onfail = /connect %1
/def -p1 -F -ag -mglob -h'BACKGROUND ' common_background_gag = /echo -ag nop
/def -p1 -F -ag -mglob -h'BGTRIG' common_bgtrig_gag = /echo -ag nop

;; Automatic logging
/def -p1 -F -ag -mglob -h'CONNECT' common_log = /log -w "logs/$[world_info()].log"

;; Command to connect to all defined worlds
/def connect_all = /mapcar /connect $(/listworlds -s)

;; Set the world order for the tab status bar
/set worldorder=SluggyMARE SolarWindsMARE GlobalVillage

;; Commands for future /common command
/def common_start_logging = \
	/log -w%{1} logs/%{1}.log

/def common_reload_logs = \
	/quote -S /common_start_logging !"sbin/enabled_worlds.pl"

/def common_reload_all = \
	/quote -S /load -q !"ls lib/enabled/*.tf"%; \
	/common_reload_logs


/def remove_common = \
	/unset installed_common %; \
	/purge common_* %; \
	/purge *_common %; \
	/echo % COMMON: removed

/set installed_common=1
/echo % COMMON: installed
