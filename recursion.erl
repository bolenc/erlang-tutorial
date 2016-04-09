-module(recursion).
-export([duplicate/2, tail_duplicate/2, tail_sublist/2, zip/2, tail_zip/2]).

duplicate(0, _) -> [];
duplicate(N,Term) when N > 0 ->
  [Term|duplicate(N-1, Term)].

tail_duplicate(N, Term) ->
  tail_duplicate(N, Term, []).

tail_duplicate(0, _, List) -> List;
tail_duplicate(N, Term, List) when N > 0 ->
  tail_duplicate(N-1, Term, [Term|List]).

tail_sublist(L, N) -> tail_sublist(L, N, []).

tail_sublist(_, 0, SubList) -> lists:reverse(SubList);
tail_sublist([], _, SubList) -> SubList;
tail_sublist([H|T], N, SubList) when N > 0 ->
  tail_sublist(T, N-1, [H|SubList]).

zip([], _) -> [];
zip(_, []) -> [];
zip([X|Xs], [Y|Ys]) ->
  [{X, Y}|zip(Xs, Ys)].

tail_zip(A, B) -> lists:reverse(tail_zip(A, B, [])).

tail_zip([], _, Acc) ->Acc;
tail_zip(_, [], Acc) ->Acc;
tail_zip([X|Xs], [Y|Ys], Acc) ->
  tail_zip(Xs, Ys, [{X,Y}|Acc]).
