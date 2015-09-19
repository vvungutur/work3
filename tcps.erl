-module(tcps).

-compile(export_all).

-import(cstore, [get_pk_id/0, write_log/3]).


start() ->
	
	{ok, Listen} = gen_tcp:listen(8850, [binary, {active, true}]),
	server(Listen).


server(LS) ->
	{ok, Accept} = gen_tcp:accept(LS),
	loop(Accept),
	server(LS).

loop(Accept) ->

	receive
        	{tcp, Socket, <<"quit", _/binary>>} ->
        		gen_tcp:close(Socket);

        	{tcp, Socket, Msg} ->
				io:format("~s~n",[Msg]),
			        gen_tcp:send(Socket, Msg),
            			loop(Socket)
    	end.

