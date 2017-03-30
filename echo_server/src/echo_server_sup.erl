%%%-------------------------------------------------------------------
%% @doc echo_server top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(echo_server_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    Flags = #{strategy => one_for_all, intensity => 0, period => 1},
    Children = [
        #{
            id => echo_server,
            type => worker,
            start => {echo_server, start_link, [9876]},
            restart => permanent
        }
    ],
    {ok, {Flags, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
