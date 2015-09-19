-module(cserver).

-compile(export_all).

-record(user, {id, userid, name, username, password}).
-record(log,  {id, chatid, userid, message}).

-include_lib("stdlib/include/qlc.hrl").

init_store() ->

		mnesia:create_schema([node()]),
		mnesia:start(),
		mnesia:create_table(user, [{attributes, record_info(fields, user)}]),
		mnesia:create_table(log, [{attributes, record_info(fields, log)}]),
		mnesia:stop().


start() ->

	mnesia:start(),
	mnesia:wait_for_tables([user, log], 200),
	bulk_write().

stop() ->
	mnesia:stop().
bulk_write() ->

	F = fun() -> lists:foreach(fun mnesia:write/1, data()) end,
	mnesia:transaction(F).

bulk_write(Data) ->

	F = fun() -> lists:foreach(fun mnesia:write/1, Data) end,
	mnesia:transaction(F).


data() ->

	[
		{user, 1, 1, "one vungutur", vv, erlang12},
		{user, 2, 2, "two vungutur", rv, clojur12},
		{user, 3, 3, "three vungutur", dv, oracle},
		{user, 4, 4, "four vungutur", rav, csharp},
		{log, 1, 1, 1, "hey how it going"},
		{log, 2, 1, 2, "good how are you"},
		{log, 3, 1, 1, "good as well"},
		{log, 4, 1, 2, "ok goodbye"},
		{log, 5, 1, 1, "goodbye"}

	].

write_log(ChatID, UserID, Message) ->
	PKID = getPK(),
	Entry = #log{id=PKID, chatid=ChatID, userid=UserID, message=Message},
	F = fun() -> mnesia:write(Entry) end,
	mnesia:transaction(F),
	all_messages().

add_user() ->
	Entry = #user{id=5, userid=5, name="five vungutur", username=wv, password=woof12},
	F = fun() -> mnesia:write(Entry) end,
	mnesia:transaction(F).
		
get_conversation(ChatID) ->

	do(qlc:q([{X#user.name, Y#log.message} || X <- mnesia:table(user), Y <- mnesia:table(log), 
	 Y#log.chatid =:= ChatID, X#user.userid =:= Y#log.id])).

get_user_messages(UserID) ->

	do(qlc:q([X#log.message || X <- mnesia:table(log), X#log.userid == UserID])).

do(Query) ->

	F = fun() -> qlc:e(Query) end,
	mnesia:transaction(F).

all_messages() ->
	do(qlc:q([X || X <- mnesia:table(log)])).

all_users() ->
	do(qlc:q([X || X <- mnesia:table(user)])).

get_chat_id() ->

		{_, Z} = do(qlc:q([X#log.chatid || X <- mnesia:table(log)])),
		lists:max(Z) + 1.
getPK() ->

		{_, Z} = do(qlc:q([X#log.id || X <- mnesia:table(log)])),
		lists:max(Z) + 1.

authenticate(UN, PW) ->
			{_, [{ID, _ , _ }]} = do(qlc:q([{X#user.id, X#user.name, X#user.username} 
			|| X <- mnesia:table(user), X#user.username =:= UN, X# user.password =:= PW])),
			ID.
testOID(Name) ->

	OID = {user, Name},
	OID.
