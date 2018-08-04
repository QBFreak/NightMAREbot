/def encode = \
	/let _input=%*%; \
	/let _i=0%; \
	/let _w=$[substr(%_input, %_i, 1)]%; \
	/while (_w !~ "") \
		/let _retval=$[strcat(%_retval, "_", ascii(%_w), "_")]%; \
		/let _i=$[_i + 1]%; \
		/let _w=$[substr(%_input, %_i, 1)]%; \
	/done %; \
	/result "%_retval"

/def decode = \
	/let _input=%*%; \
	/let _i=32%; \
	/while (_i < 48) \
		/let _input=$[decodechar(%_i, %_input)]%; \
		/let _i=$[_i + 1]%; \
	/done %; \
	/let _i=58%; \
	/while (_i < 65) \
		/let _input=$[decodechar(%_i, %_input)]%; \
		/let _i=$[_i + 1]%; \
	/done %; \
	/let _i=91%; \
	/while (_i < 95) \
		/let _input=$[decodechar(%_i, %_input)]%; \
		/let _i=$[_i + 1]%; \
	/done %; \
	/let _input=$[decodechar(96, %_input)]%; \
	/let _i=123%; \
	/while (_i < 127) \
		/let _input=$[decodechar(%_i, %_input)]%; \
		/let _i=$[_i + 1]%; \
	/done %; \
	/let _input=$[decodechar(95, %_input)]%; \
	/result "%_input"

/def decodechar = \
	/result "$[replace(strcat('_', %1, '_'), char(%1), %2)]"
