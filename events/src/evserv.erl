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
      case valid_datetime(TimeOut) of
        true ->
          EventPid = event:start_link(Name, TimeOut),
          NewEvents = ordict:store(Name,
                                    #event{name=Name,
                                            description=Description,
                                            pid=EventPid,
                                            timeout = TimeOut},
                                    S#state.events),
          Pid ! {MsgRef, ok},
          loop(S#state{events = NewEvents});
        false ->
          Pid ! {MsgRef, {error, bad_timeout}},
          loop(S)
      end;
    {Pid, MsgRef, {cancel, Name}} -> true;
      %%...
    {done, Name} -> true;
      %%...
    shutdown -> true;
      %%...
    {'DOWN', Ref, process, _Pid, _Reason} -> true;
      %%...
    code_change -> true;
      %%...
    Unknown ->
      io:format("Unknown message: ~p~n", [Unknown]),
      loop(S)
  end.

valid_datetime({Date, Time}) ->
  try
    calendar:valid_date(Date) andalso valid_time(Time)
  catch
    error:function_clause ->
      false
  end;
valid_datetime(_) ->
  false.

valid_time({H,M,S}) -> valid_time(H, M, S).
valid_time(H, M, S) when H >=0, H < 24,
                        M >= 0, M < 60,
                        S >= 0, S < 60 -> true;
valid_time(_,_,_) -> false.
