/def -F -aA -mregexp -Tslack -t'.*' hubot_noact
/def -Fp1 -E{hubot_enabled} -mregexp -Tslack -t'^\\[.*\\] INFO Message: (.*)' hubot = /send -wSluggyMARE hubot %{P1}
/def -p99 -E{hubot_enabled} -mregexp -Tdiku -ag -t'^@@TFGAG (.*)$' hubot_tfgag = /def -n1 -p999 -ag -mregexp -Tdiku -t"\^SLACK %P1\$"
/def -p1 -E{hubot_enabled} -mregexp -Tdiku -ag -t'^SLACK (.*)$' hubot_slack = /quote -w$[world_info()] -S SLACK !"/usr/bin/perl ~/sbin/slack/sendmsg.pl %{P1}"

/def remove_hubot = \
    /undef hubot_noact %; \
    /undef hubot %; \
    /undef hubot_tfgag %; \
    /undef hubot_slack_oneshot %; \
    /undef hubot_slack %; \
    /unset installed_hubot %; \
    /unset hubot_unabled %; \
    /undef remove_hubot %; \
    /echo % HUBOT: removed

/def disable_hubot = \
    /set hubot_enabled 0 %; \
    /echo % HUBOT: disabled

/def enable_hubot = \
    /set hubot_enabled 1 %; \
    /echo % HUBOT: enabled

/set installed_hubot 1
/echo % HUBOT: installed
/enable_hubot

