-module(client).

-compile(export_all).


	

start(Port) ->
	{Descriptor, Socket} = gen_tcp:connect("localhost", Port, [{active, false}, {packet, 2}]),

	case Descriptor of
		error ->
			io:format("server connection refused~n", []);
		_ ->
			action(Socket)

	end.


action(Socket) ->

	{ok, Input} = io:fread("-> ", "~s"),

	Message = list_to_atom(Input),

	case Message of 

	q -> 
		io:format("done", []);
%		gen_tcp:close(Socket);

	
	_ -> 
	
		io:format(":: ~s~n", [Message]),
%		gen_tcp:send(Socket, Message),
		action(Socket)

	end.

