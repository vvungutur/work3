-module(ttcp).

-compile(export_all).


start(LPort) ->
    case gen_tcp:listen(LPort,[{active, false},{packet,2}]) of
        {ok, ListenSock} ->
            start_server(ListenSock),
            {ok, Port} = inet:port(ListenSock),
            Port;
        {error,Reason} ->
            {error,Reason}
    end.

start_server(Listen_Socket) ->
	spawn(?MODULE, server, [Listen_Socket]),
	io:format("server stated~n", []).

server(Listen_Socket) ->
	{ok, S} = gen_tcp:accept(Listen_Socket),
	loop(S),
	server(Listen_Socket).

loop(S) ->
	inet:setopts(S, [{active, once}]),

	receive 
		{tcp, S, Data} ->
			io:format("~s~n", [Data]),
			loop(S);
		{tcp_closed, S} ->
			io:format("tis closed~n", [])
	end.
