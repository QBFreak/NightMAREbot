/set spell_badchar=<>;|&
; GETSPELLING <channel> <string> -- Checks the spelling of <string> and returns the results in the format of $ SPELLING <channel> <annotated string>
/def -Fp1 -ag -mregexp -t'^GETSPELLING ([^ <>;|]+) ([^<>;|]+)' getspelling = /quote -w$[world_info()] SPELLING %{P1} !"~/sbin/spell/getspell.sh %{P2}"
; SUGGEST <channel> <word> -- Retrieves spelling suggestions for <word> and returns the results in the format of $ SUGGEST <channel> <suggestion list>
/def -Fp1 -ag -mregexp -t'^SUGGEST ([^ <>;|]+) ([^<>;|]+)' suggest = /quote -w$[world_info()] SUGGEST %{P1} !"~/sbin/spell/suggest.sh %{P2}"

; CHECKSPELLING_MARKER <dbref> <marker> <string> -- Checks the spelling of <string> and returns the results in the format of $ SPELLING_MARKER <dbref> <marker> <annoted string>
; This particular variant lets us check the spelling while specifying what character 'marks' (surrounds) the misspelling
; We do some magic to escape certain characters in the <dbref> and <marker> that TF doesn't like in the [pre] section of /quote
; We also have to preserve all the %Pn variables before we call regmatch() because it obliterates them all
/def -Fpq -ag -mregexp -t'^CHECKSPELLING_MARKER (#[0-9]+) ([^ <>;|&]) ([^<>;|&]+)$' checkspelling_marker = \
    /let dbref=$[strcat("\\", %P1)]%; \
    /let marker=%P2%; \
    /let escmarker=%P2%; \
    /let text=%P3%; \
;   If the marker is any of '!`# escape it so we can use it in the [pre] section of /quote
    /if (regmatch("^('|!|`|#)$", %marker)) \
        /let escmarker=$[strcat("\\", %marker)]%; \
    /endif %; \
    /quote -w$[world_info()] SPELLING_MARKER %dbref %escmarker !"~/sbin/spell/checkspell.pl --marker=%marker %text"

/def remove_spell = \
	/undef getspelling %; \
	/undef suggest %; \
	/unset installed_spell %; \
        /unset spell_badchar %; \
	/undef remove_spell %; \
	/echo % SPELL: removed

/set installed_spell=1
/echo % SPELL: installed
