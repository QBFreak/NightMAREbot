; Function - returns 1 if the module is installed, nothing otherwise
/def module_installed = /return "$(/eval /echo $[strcat("%", "installed_", {1})])"

; Add a module to the list of installed modules
/def module_register = \
	if ($[module_installed({1})]) \
		/echo % MODULES: %{1} is already registered. %; \
	/else \
		/set module_list = %{module_list} %{1} %; \
		/echo % MODULES: %{1} registered. %; \
	/endif

; Remove a module from the list of installed modules
/def module_unregister = \
	if ($[module_installed({1})]) \
		/set module_list = %{module_list} %{1} %; \
		/echo % MODULES: %{1} registered. %; \
	/else \
		/echo % MODULES: %{1} is already registered. %; \
	/endif

; Find out if module is installed
/def module_check = \
	/if ($[module_installed({1})]) \
		/echo % MODULES: %{1} is installed. %; \
	/else \
		/echo % MODULES: %{1} is not installed. %; \
	/endif

/def remove_modules = \
	/purge module_* %; \
	/undef remove_modules
