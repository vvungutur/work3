-module(close).

-compile(export_all).


close(Port) ->
		inet:close(Port).
