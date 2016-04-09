-module(functions).
-compile(export_all).

greet(male, Name) ->
  io:format("Hello, Mr. ~s!~n", [Name]);
greet(female, Name) ->
  io:format("Hello, Ms. ~s!~n", [Name]);
greet(_, Name) ->
  io:format("Hello, ~s!~n", [Name]).

head([H|_]) -> H.

second([_, X | _]) -> X.

valid_time({Date = {Y,M,D}, Time = {H, Min, S}}) ->
  io:format("The Date tuple (~p) says today is: ~p/~p/~p,~n", [Date,Y,M,D]),
  io:format("The time tuple (~p) indicates ~p:~p:~p.~n", [Time, H, Min, S]);
valid_time(_) ->
  io:format("Bad data!~n").
