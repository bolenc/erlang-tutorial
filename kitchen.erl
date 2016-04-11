-module(kitchen).
-compile(export_all).

fridge1() ->
  receive
    {From, {store, _Food}} ->
      From ! {self(), ok},
      fridge1();
    {From, {take, _Food}} ->
      From ! {self(), not_found},
      fridge1();
    terminate ->
      ok
  end.

fridge2(Contents) ->
  receive
    {From, {store, Food}} ->
      From ! {self(), ok},
      fridge2([Food|Contents]);
    {From, {take, Food}} ->
      case lists:member(Food, Contents) of
        true ->
          From ! {self(), {ok, Food}},
          fridge2(lists:delete(Food, Contents));
        false ->
          From ! {self(), not_found},
          fridge2(Contents)
      end;
    terminate ->
      ok
  end.

start(Contents) ->
  spawn(?MODULE, fridge2, [Contents]).

store(Pid, Food) ->
  Pid ! {self(), {store, Food}},
  receive
    {Pid, Msg} -> Msg
  end.

take(Pid, Food) ->
  Pid ! {self(), {take, Food}},
  receive
    {Pid, Msg} -> Msg
  end.

store2(Pid, Food) ->
  Pid ! {self(), {store, Food}},
  receive
    {Pid, Msg} -> Msg
  after 3000 ->
    timeout
  end.

take2(Pid, Food) ->
  Pid ! {self(), {take, Food}},
  receive
    {Pid, Msg} -> Msg
  after 3000 ->
    timeout
  end.
