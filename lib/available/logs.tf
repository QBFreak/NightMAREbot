; Manually start logging a single world
/def start_logging = \
        /log_one %{1}

; Commands for use to automatically start logging ALL worlds, including
;  "tab" worlds (worlds with : in the name)
/def log_one = /log -w%{1} logs/$[replace(":","_",{1})].log
/def log_all = /mapcar /log_one $(/listworlds -s)

/set installed_logs=1
/echo % LOGS: installed

