-module(echo_server).

-export([start_link/1, start/1, client_loop/1]).


start_link(Port) ->
    io:format("start_link ~p~n", [self()]),
    proc_lib:start_link(?MODULE, start, [Port]).


start(PortNumber) ->
    io:format("start ~p~n", [self()]),
    {ok, ListenSocket} = gen_tcp:listen(PortNumber, [{active, true}, binary]),
    loop(ListenSocket).


%% @private
loop(ListenSocket) ->
    {ok, AcceptSocket} = gen_tcp:accept(ListenSocket),
    Pid = spawn(?MODULE, client_loop, [AcceptSocket]),
    gen_tcp:controlling_process(AcceptSocket, Pid),
    loop(ListenSocket).

%% @private
client_loop(AcceptSocket) ->
    io:format("started client connection ~p~n", [AcceptSocket]),
    inet:setopts(AcceptSocket, [{active, once}]),
    receive
        {tcp, AcceptSocket, <<"quit", _/binary>>} ->
            io:format("clossing socket ~p~n", [AcceptSocket]),
            gen_tcp:close(AcceptSocket);
        {tcp, AcceptSocket, Msg} ->
            gen_tcp:send(AcceptSocket, Msg),
            io:format("Message recievd from client ~p~n", [Msg]),
            client_loop(AcceptSocket)
    end.

    