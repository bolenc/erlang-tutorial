-module(dolphins).
-compile(export_all).

dolphin1() ->
  receive
    do_a_flip ->
      io:format("No?!~n");
    fish ->
      io:format("So long!~n");
    _ ->
      io:format("Heh~n")
  end.

dolphin2() ->
  receive
    {From, do_a_flip} ->
      From ! "No?!";
    {From, fish} ->
      From ! "So long!";
    _ ->
      io:format("Heh~n")
  end.

dolphin3() ->
  receive
    {From, do_a_flip} ->
      From ! "No?!",
      dolphin3();
    {From, fish} ->
      From ! "So long!";
    _ ->
      io:format("Heh~n"),
      dolphin3()
  end.
