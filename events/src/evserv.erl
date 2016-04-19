-module(evserv).
-compile(export_all).

-record(state, {events, clients}).
-record(event,
    {name="",
    description="",
    pid,
    timeout={{1970,1,1},{0,0,0}}}).

init() ->
  loop(#state{events=ordict:new(),
              clients=ordict:new()}).

loop(S= #state{}) ->
  receive
    {Pid, MsgRef, {subscribe, Client}} ->
      Ref=erlang:monitor(process, Client),
      NewClients = ordict:store(Ref, Client, S#state.clients),
      Pid ! {MsgRef, ok},
      loop(S#state{clients=NewClients});
    {Pid, MsgRef, {add, Name, Description, TimeOut}} ->
      ...
    {Pid, MsgRef, {cancel, Name}} ->
      ...
    {done, Name} ->
      ...
    shutdown ->
      ...
    {'DOWN', Ref, process, _Pid, _Reason} ->
      ...
    code_change ->
      ...
    Unknown ->
      io:format("Unknown message: ~p~n", [Unknown]),
      loop(State)
  end.